# frozen_string_literal: true

require "tabulard/adapters/csv"
require "support/shared/table/factories"
require "support/shared/table/empty"
require "support/shared/table/filled"
require "csv"
require "stringio"

RSpec.describe Tabulard::Adapters::Csv do
  include_context "table/factories"

  let(:input) do
    stub_input(source)
  end

  let(:table_opts) do
    {}
  end

  let(:table) do
    described_class.new(input, **table_opts)
  end

  def stub_input(source)
    csv = CSV.generate do |csv_io|
      source.each do |row|
        csv_io << row
      end
    end

    StringIO.new(csv, "r:UTF-8")
  end

  after do |example|
    table.close unless example.metadata[:autoclose_table] == false
    input.close
  end

  context "when the input table is empty" do
    let(:source) do
      []
    end

    include_examples "table/empty"
  end

  context "when the input table is filled" do
    let(:source) do
      Array.new(4) do |row|
        Array.new(4) do |col|
          "(#{row},#{col})"
        end.freeze
      end.freeze
    end

    include_examples "table/filled"
  end

  describe "encodings" do
    let(:utf8_path) { fixture_path("csv/utf8.csv") }
    let(:latin9_path) { fixture_path("csv/latin9.csv") }

    let(:headers_data_utf8) do
      [
        "Matricule",
        "Nom",
        "Prénom",
        "Email",
        "Date de naissance",
        "Entrée en entreprise",
        "Administrateur",
        "Bio",
        "Service",
      ]
    end

    let(:headers_data_latin9) do
      headers_data_utf8.map { |str| str.encode(Encoding::ISO_8859_15) }
    end

    let(:table_headers_data) { table.each_header.map(&:value) }

    context "when the IO is opened with the correct external encoding" do
      let(:input) do
        File.new(latin9_path, external_encoding: Encoding::ISO_8859_15)
      end

      it "does not interfere" do
        expect(table_headers_data).to eq(headers_data_latin9)
      end
    end

    context "when the IO is opened with an incorrect external encoding" do
      let(:input) do
        File.new(latin9_path, external_encoding: Encoding::UTF_8)
      end

      it "fails" do
        expect { table }.to raise_error(described_class::InputError)
      end
    end

    context "when the (correct) external encoding differs from the internal one" do
      let(:input) do
        File.new(
          latin9_path,
          external_encoding: Encoding::ISO_8859_15,
          internal_encoding: Encoding::UTF_8
        )
      end

      it "does not interfere" do
        expect(table_headers_data).to eq(headers_data_utf8)
      end
    end
  end

  describe "CSV options" do
    let(:source) { [] }

    it "requires a specific col_sep and quote_char, and an automatic row_sep" do
      expect(CSV).to receive(:new)
        .with(input, row_sep: :auto, col_sep: ",", quote_char: '"')
        .and_call_original

      table
    end
  end

  describe "#close" do
    let(:source) { [] }

    it "doesn't close the underlying table" do
      expect { table.close }.not_to change(input, :closed?).from(false)
    end
  end
end
