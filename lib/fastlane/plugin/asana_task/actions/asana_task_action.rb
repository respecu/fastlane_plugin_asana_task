require 'fastlane/action'
require_relative '../helper/asana_task_helper'
require 'json'
require 'httparty'

module Fastlane
  module Actions
    class AsanaTaskAction < Action
      def self.run(params)
        UI.message("The asana_task plugin is working!")

        asana_url = "https://app.asana.com/api/1.0/tasks"

        headers = { 
          "Content-Type"  => "application/json",
          "Accept" => "application/json",
          "Authorization" => "Bearer #{params[:accessToken]}"
        }

        message = {
          data: {
            approval_status: "pending",
            completed: false,
            liked: false,
            name: params[:taskName],       
            notes: params[:description],
            assignee: params[:assigneeId],            
            projects: [                              
              params[:projectId]
            ]
          }
        }

        UI.message(message.to_json)

        #Send the request
        response = HTTParty.post(asana_url, :headers => headers, body: message.to_json)
        UI.message("response : #{response}")

        sectionId = params[:sectionId]
        if sectionId != nil or sectionId != ""
          asana_section_url = "https://app.asana.com/api/1.0/sections/#{sectionId}/addTask"

          sectionBody = {
            data: {
              task: response[:data[:gid]]
            }
          }

          response = HTTParty.post(asana_section_url, :headers => headers, body: sectionBody.to_json)
          UI.message("response : #{response}")
        end
      end

      def self.description
        "asana task plugin"
      end

      def self.authors
        ["respecu"]
      end

      def self.return_value
        # If your method provides a return value, you can describe here what it does
      end

      def self.details
        # Optional:
        "asana task plugin"
      end

      def self.available_options
        [
          FastlaneCore::ConfigItem.new(key: :accessToken,
                                  env_name: "ACCESS_TOKEN",
                               description: "Asana web hook token",
                                  optional: false,
                                      type: String),

          FastlaneCore::ConfigItem.new(key: :taskName,
                                  env_name: "TASK_NAME",
                               description: "Asana task name",
                                  optional: false,
                                      type: String),

          FastlaneCore::ConfigItem.new(key: :description,
                                  env_name: "DESCRIPTION",
                                description: "Asana task description",
                                  optional: false,
                                      type: String),
          
          FastlaneCore::ConfigItem.new(key: :assigneeId,
                                  env_name: "ASSIGNEE_ID",
                                description: "task asignee",
                                  optional: false,
                                      type: String),

          FastlaneCore::ConfigItem.new(key: :projectId,
                                  env_name: "PROJECT_ID",
                                description: "project id for task",
                                  optional: true,
                                      type: String),

          FastlaneCore::ConfigItem.new(key: :sectionId,
                                  env_name: "SECTION_ID",
                                description: "section id for task",
                                  optional: true,
                                      type: String)
        ]
      end

      def self.is_supported?(platform)
        # Adjust this if your plugin only works for a particular platform (iOS vs. Android, for example)
        # See: https://docs.fastlane.tools/advanced/#control-configuration-by-lane-and-by-platform
        #
        # [:ios, :mac, :android].include?(platform)
        true
      end
    end
  end
end
