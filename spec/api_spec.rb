require 'query'
require 'json'

RSpec.describe 'artisan API' do
  let(:base_query)    { Query.new(base.address, base.key) }
  let(:compare_query) { Query.new(compare.address, compare.key) }

  def expect_match(compare, base)
    expect(compare.code).to eq(base.code)
    expect(compare.parsed_response).to eq(base.parsed_response)
  end

  describe 'get api/projects' do
    it 'valid request' do
      expect_match(compare_query.get_project, base_query.get_project)
    end

    it 'with bad key' do
      base_query.key = 'bad'
      compare_query.key = 'bad'

      expect_match(compare_query.get_project, base_query.get_project)
    end
  end

  describe 'get api/projects/iterations' do
    it 'valid request' do
      expect_match(compare_query.get_iterations, base_query.get_iterations)
    end

    it 'with bad key' do
      base_query.key = 'bad'
      compare_query.key = 'bad'

      expect_match(compare_query.get_iterations, base_query.get_iterations)
    end
  end

  describe 'get api/projects/iterations/:number/total_billed_points_by_craftsman' do
    # both 500 with bad iteration number
    let(:iteration_number) { 1 }

    it 'valid request' do
      expect_match(compare_query.get_iteration_total_billed_points_by_craftsman(iteration_number), base_query.get_iteration_total_billed_points_by_craftsman(iteration_number))
    end

    it 'with bad key' do
      base_query.key = 'bad'
      compare_query.key = 'bad'

      expect_match(compare_query.get_iteration_total_billed_points_by_craftsman(iteration_number), base_query.get_iteration_total_billed_points_by_craftsman(iteration_number))
    end
  end

  describe 'get api/projects/stories' do
    it 'valid request' do
      expect(base_query.get_stories.code).to eq(compare_query.get_stories.code)

      uno_response = base_query.get_stories.parsed_response
      deux_response = compare_query.get_stories.parsed_response

      uno_response.each_with_index do |story, index|
        # accounts for disconnect between intended vs actual behavior of existing API
        story.delete("assigned_user")
        story.delete("assigned_user_options")
        expect(story.to_a).to eq(story.to_a & deux_response[index].to_a)
      end
    end

    it 'with bad key' do
      base_query.key = 'bad'
      compare_query.key = 'bad'

      expect_match(compare_query.get_stories, base_query.get_stories)
    end
  end
end
