require "fileutils"

RSpec.describe NextRails do
  it "has a version number" do
    expect(NextRails::VERSION).not_to be nil
  end

  describe "NextRails.next?" do
    context "when BUNDLE_GEMFILE is not set" do
      it "returns false" do
        expect(NextRails.next?).to be_falsey
      end
    end

    context "when BUNDLE_GEMFILE is set" do
      context "when it is set to Gemfile.next" do
        it "returns true" do
          FileUtils.touch("Gemfile.next")
          NextRails.reset_next_bundle_gemfile

          ClimateControl.modify BUNDLE_GEMFILE: "Gemfile.next" do
            expect(NextRails.next?).to be_truthy
          end
        end

        context "when Gemfile.next file does not exist" do
          it "returns false" do
            FileUtils.rm("Gemfile.next")
            NextRails.reset_next_bundle_gemfile

            ClimateControl.modify BUNDLE_GEMFILE: "Gemfile.next" do
              expect(NextRails.next?).to be_falsey
            end
          end
        end
      end

      context "when it is set to something else" do
        it "returns false" do
          FileUtils.touch("Gemfile4")
          NextRails.reset_next_bundle_gemfile

          ClimateControl.modify BUNDLE_GEMFILE: "Gemfile4" do
            expect(NextRails.next?).to be_falsey
          end

          FileUtils.rm("Gemfile4")
        end
      end
    end
  end

end
