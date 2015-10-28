require 'query'
require 'json'

RSpec.describe 'artisan API' do
  let(:base_query)    { Query.new(base.address, base.key) }
  let(:compare_query) { Query.new(compare.address, compare.key) }

  def expect_match(compare, base)
    expect(compare.code).to eq(base.code)
    expect(compare.parsed_response).to eq(base.parsed_response)
  end

  def expect_match_all_but_assigned_user(compare_query_request, base_query_request)
    expect(base_query_request.code).to eq(compare_query_request.code)

    uno_response = base_query_request.parsed_response
    deux_response = compare_query_request.parsed_response

    uno_response.zip(deux_response) do |uno, deux|
      uno.delete("assigned_user")
      uno.delete("assigned_user_options")
      expect(uno.to_a).to eq(uno.to_a & deux.to_a)
    end
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
      compare_query_request = compare_query.get_stories
      base_query_request = base_query.get_stories
      expect_match_all_but_assigned_user(compare_query_request, base_query_request)
    end

    it 'with bad key' do
      base_query.key = 'bad'
      compare_query.key = 'bad'

      expect_match(compare_query.get_stories, base_query.get_stories)
    end
  end

  describe 'get api/projects/stories/backlog' do
    it 'valid request' do
      compare_query_request = compare_query.get_backlog_stories
      base_query_request = base_query.get_backlog_stories
      expect_match_all_but_assigned_user(compare_query_request, base_query_request)
    end

    it 'with bad key' do
      base_query.key = 'bad'
      compare_query.key = 'bad'

      expect_match(compare_query.get_backlog_stories, base_query.get_backlog_stories)
    end
  end

  describe 'get api/projects/iterations/stories' do
    it 'valid request' do
      compare_query_request = compare_query.get_stories_by_iteration(1)
      base_query_request = base_query.get_stories_by_iteration(1)
      expect_match_all_but_assigned_user(compare_query_request, base_query_request)
    end

    it 'with bad key' do
      base_query.key = 'bad'
      compare_query.key = 'bad'

      expect_match(compare_query.get_stories_by_iteration(1), base_query.get_stories_by_iteration(1))
    end
  end
end
