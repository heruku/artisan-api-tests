#!/usr/bin/env ruby

require 'sequel'

databases = ['artisan-development', 'artisan-deux-development']
frozen_time = Time.now
api_key = 'project_api_key'
other_api_key = 'other_api_key'

databases.each do |name|
  db = Sequel.connect(
    adapter: 'mysql2',
    user: 'root',
    host: 'localhost',
    database: name
  )

  db.from(:users).delete
  db.from(:projects).delete
  db.from(:iterations).delete
  db.from(:stories).delete
  db.from(:project_configurations).delete

  if name == 'artisan-development'
    Sequel.default_timezone = :utc
  else
    Sequel.default_timezone = :local
  end

  user_id = db.from(:users).insert(
    id: 1,
    login: 'user',
    created_at: frozen_time,
    updated_at: frozen_time,
    email: 'email@email.com',
    full_name: 'first last',
    uid: 'asasdsad',
    provider: 'google'
  )

  other_user_id = db.from(:users).insert(
    id: 2,
    login: 'other_user',
    created_at: frozen_time,
    updated_at: frozen_time,
    email: 'other_email@email.com',
    full_name: 'other name',
    uid: 'uidnritu',
  )

  project_id = db.from(:projects).insert(
    id: 1,
    name: 'Project name',
    description: 'Project decsription',
    life_cycle: 7,
    api_key: api_key,
    created_at: frozen_time,
    updated_at: frozen_time
  )

  other_project_id = db.from(:projects).insert(
    id: 2,
    name: 'Other project name',
    description: 'Other project description',
    life_cycle: 7,
    api_key: other_api_key,
    created_at: frozen_time,
    updated_at: frozen_time
  )

  project_configuration = db.from(:project_configurations).insert(
    id: 1,
    project_id: project_id,
    api_key: api_key,
    estimate_mode: "estimate-mode",
    created_at: frozen_time,
    updated_at: frozen_time
  )

  other_project_configuration = db.from(:project_configurations).insert(
    id: 2,
    project_id: other_project_id,
    api_key: other_api_key,
    estimate_mode: 'estimate-mode',
    created_at: frozen_time,
    updated_at: frozen_time
  )

  iteration_id = db.from(:iterations).insert(
    id: 1,
    project_id: project_id,
    committed_points: 30,
    committed_points_at_completion: 35,
    number: 1,
    start_date: frozen_time,
    finish_date: frozen_time,
    completed_at: frozen_time,
    complete: true,
    created_at: frozen_time,
    updated_at: frozen_time
  )

  other_iteration_id = db.from(:iterations).insert(
    id: 2,
    project_id: other_project_id,
    committed_points: 15,
    committed_points_at_completion: 16,
    number: 1,
    start_date: frozen_time,
    finish_date: frozen_time,
    completed_at: frozen_time,
    complete: true,
    created_at: frozen_time,
    updated_at: frozen_time
  )

  story_attributes = {
    id: 1,
    iteration_id: iteration_id,
    optimistic: 1,
    realistic: 2,
    pessimistic: 3,
    project_id: project_id,
    acceptance_criteria: "Make good stuff",
    deleted: false,
    assigned_user_id: user_id,
    creator_id: user_id,
    nonbillable: false,
    completed_at: frozen_time,
    created_at: frozen_time,
    updated_at: frozen_time
  }

  other_story_attributes = {
    id: 2,
    iteration_id: other_iteration_id,
    optimistic: 2,
    realistic: 3,
    pessimistic: 4,
    project_id: other_project_id,
    acceptance_criteria: "Make bad stuff",
    deleted: false,
    assigned_user_id: other_user_id,
    creator_id: other_user_id,
    nonbillable: false,
    completed_at: frozen_time,
    created_at: frozen_time,
    updated_at: frozen_time
  }

  if name == 'artisan-development'
    story_attributes.merge!(complete: true)
    other_story_attributes.merge!(complete: true)
  end

  story_id = db.from(:stories).insert(story_attributes)
  other_story_id = db.from(:stories).insert(other_story_attributes)
end

puts "Ready to go, just copy '#{api_key}' to the .config file as the api key"
