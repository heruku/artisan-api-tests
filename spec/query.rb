require 'httparty'

class Query
  attr_accessor :address, :key

  def initialize(address, key)
    @address = address
    @key = key
  end

  def get_project
    HTTParty.get "http://#{address}/api/projects", :headers => {'accept' => 'application/json'}, :query => {'key' => key}
  end

  def get_iterations
    HTTParty.get "http://#{address}/api/projects/iterations", :headers => {'accept' => 'application/json'}, :query => {'key' => key}
  end

  def get_iteration_total_billed_points_by_craftsman(iteration_number)
    HTTParty.get "http://#{address}/api/projects/iterations/#{iteration_number}/total_billed_points_by_craftsman", :headers => {'accept' => 'application/json'}, :query => {'key' => key}
  end

  def get_signoff_pdf(iteration_id)
    HTTParty.get(
      'http://' + address + '/api/reports',
      :headers => {
        'accept' => 'application/pdf'
      },
      :query => {
        'key' => key,
        'options'  => {
          'iteration_id' => iteration_id,
          'show_owner' => '1',
          'sections'   => {
            'Completed' => '1',
            'Features'  => '1',
            'Tasks'     => '1',
            'Untagged'  => '0'
          }
        }
      }
    )
  end

  def get_stories_by_iteration(iteration_number)
    HTTParty.get(
      "http://#{address}/api/projects/iterations/stories",
      :headers => {
        'accept' => 'application/json'
      },
      :query => {
        'key' => key,
        'iteration_number' => iteration_number
      }
    )
  end

  def get_stories
    HTTParty.get "http://#{address}/api/projects/stories", :headers => {'accept' => 'application/json'}, :query => {'key' => key}
  end

  def get_backlog_stories
    HTTParty.get "http://#{address}/api/projects/stories/backlog", :headers => {'accept' => 'application/json'}, :query => {'key' => key}
  end

  def update_estimates(story)
    response = HTTParty.put "http://#{address}/api/projects/stories/#{story.number.to_s}/estimates", :query => {:key => key}, :headers => {'accept' => 'application/json', 'content-type' => 'application/json'}, :body => {"optimistic" => story.optimistic, "realistic" => story.realistic, "pessimistic" => story.pessimistic}.to_json
    response.body
  end

  def authenticate(username, password)
    response = HTTParty.get "http://#{address}/api/auth/authenticate", :headers => {'accept' => 'application/json'}, :query => {'username' => username, 'password' => password}
    response.body
  end

  def get_users
    HTTParty.get "http://#{address}/api/projects/users", :headers => { 'accept' => 'application/json' }, :query => { 'key' => key }
  end
end
