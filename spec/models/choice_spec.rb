require 'rails_helper'

RSpec.describe Choice, type: :model do
  it { is_expected.to belong_to :question }
  it { is_expected.to have_many :votes }
end
