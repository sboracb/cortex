Bundler.require(:default, Rails.env)

namespace :employer do
  namespace :blog do
    desc 'Seed Employer Blog ContentType and Fields'
    task seed: :environment do
      def research_tree
        tree = Tree.new
        tree.add_node({name: "CB Research"})
        tree.add_node({name: "Third Party Research"})

        tree
      end

      def category_tree
        tree = Tree.new
        tree.add_node({ name: "Candidate Experience" })
        tree.add_node({ name: "Recruitment Techniques" })
        tree.add_node({ name: "Talent Sourcing" })
        tree.add_node({ name: "Hiring Strategy" })
        tree.add_node({ name: "Data and Analytics" })
        tree.add_node({ name: "Recruitment Technology" })
        tree.add_node({ name: "Workplace Insights" })
        tree.add_node({ name: "News and Trends" })

        tree
      end

      def persona_tree
        tree = Tree.new
        tree.add_node({name: "Recruiters"})
        tree.add_node({name: "Sourcers"})
        tree.add_node({name: "Managers/Directors"})
        tree.add_node({name: "C-Level"})
        tree.add_node({name: "General Audience"})

        tree
      end

      def onet_tree
        tree = Tree.new

        industries_seed = SeedData.onet_industries

        industries_seed.each do |industry|
          tree.add_node({name: industry[:title]})
        end

        Onet::Occupation.industries.each do |onet_code|
        end

        tree
      end

      puts "Creating Employer Blog ContentType..."
      blog = ContentType.new({
                               name: "Employer Blog",
                               description: "Blog for Employer",
                               icon: "description",
                               creator_id: 1,
                               contract_id: 1,
                               publishable: true
                             })
      blog.save

      puts "Creating Fields..."
      blog.fields.new(name: 'Body', field_type: 'text_field_type', metadata: {wysiwyg: true, parse_widgets: true})
      blog.fields.new(name: 'Title', field_type: 'text_field_type', validations: {presence: true})
      blog.fields.new(name: 'Description', field_type: 'text_field_type', validations: {presence: true})
      blog.fields.new(name: 'Slug', field_type: 'text_field_type', validations: {presence: true})
      blog.fields.new(name: 'Author', field_type: 'user_field_type', validations: {presence: true})
      blog.fields.new(name: 'Tags', field_type: 'tag_field_type')
      blog.fields.new(name: 'Publish Date', field_type: 'date_time_field_type')
      blog.fields.new(name: 'Expiration Date', field_type: 'date_time_field_type')
      blog.fields.new(name: 'SEO Title', field_type: 'text_field_type')
      blog.fields.new(name: 'SEO Description', field_type: 'text_field_type')
      blog.fields.new(name: 'SEO Keywords', field_type: 'tag_field_type')
      blog.fields.new(name: 'No Index', field_type: 'boolean_field_type')
      blog.fields.new(name: 'No Follow', field_type: 'boolean_field_type')
      blog.fields.new(name: 'No Snippet', field_type: 'boolean_field_type')
      blog.fields.new(name: 'No ODP', field_type: 'boolean_field_type')
      blog.fields.new(name: 'No Archive', field_type: 'boolean_field_type')
      blog.fields.new(name: 'No Image Index', field_type: 'boolean_field_type')
      blog.fields.new(name: 'Categories', field_type: 'tree_field_type', metadata: {allowed_values: category_tree}, validations: {maximum: 2})
      blog.fields.new(name: 'Research', field_type: 'tree_field_type', metadata: {allowed_values: research_tree}, validations: {minimum: 1})
      blog.fields.new(name: 'Persona', field_type: 'tree_field_type', metadata: {allowed_values: persona_tree})

      puts "Saving Employer Blog..."
      blog.save

      puts "Creating Wizard Decorators..."
      wizard_hash = {
        "steps": [
          {
            "name": "Write",
            "heading": "First thing's first..",
            "description": "Author your post using Cortex's WYSIWYG editor.",
            "columns": [
              {
                "heading": "Writing Panel Sections's Optional Heading",
                "grid_width": 12,
                "display": {
                  "classes": [
                    "text--right"
                  ]
                },
                "elements": [
                  {
                    "id": blog.fields.find_by_name('Title').id
                  },
                  {
                    "id": blog.fields.find_by_name('Body').id,
                    "render_method": "wysiwyg",
                    "input": {
                      "display": {
                        "styles": {
                          "height": "500px"
                        }
                      }
                    }
                  }
                ]
              }
            ]
          },

          {
            "name": "Details",
            "heading": "Let's talk about your post..",
            "description": "Provide details and metadata that will enhance search or inform end-users.",
            "columns": [
              {
                "heading": "Publishing (Optional Heading)",
                "grid_width": 6,
                "elements": [
                  {
                    "id": blog.fields.find_by_name('Tags').id
                  },
                  {
                    "id": blog.fields.find_by_name('Expiration Date').id
                  },
                  {
                    "id": blog.fields.find_by_name('Publish Date').id
                  }
                ]
              },
              {
                "grid_width": 6,
                "elements": [
                  {
                    "id": blog.fields.find_by_name('Description').id
                  },
                  {
                    "id": blog.fields.find_by_name('Slug').id
                  },
                  {
                    "id": blog.fields.find_by_name('Author').id
                  }
                ]
              }
            ]
          },
          {
            "name": "Categorize",
            "heading": "Sort Into Categories..",
            "description": "Select the categories that best describe your post.",
            "columns": [
              {
                "heading": "Publishing (Optional Heading)",
                "grid_width": 4,
                "elements": [
                  {
                    "id": blog.fields.find_by_name('Categories').id,
                    "render_method": "checkboxes"
                  }
                ]
              },
              {
                "grid_width": 4,
                "elements": [
                  {
                    "id": blog.fields.find_by_name('Persona').id,
                    "render_method": "dropdown"
                  }
                ]
              },
              {
                "grid_width": 4,
                "elements": [
                  {
                    "id": blog.fields.find_by_name('Research').id,
                    "render_method": "dropdown"
                  }
                ]
              }
            ]
          },
          {
            "name": "Search",
            "heading": "How can others find your post..",
            "description": "Provide SEO metadata to help your post get found by your Users!",
            "columns": [
              {
                "heading": "Publishing (Optional Heading)",
                "grid_width": 6,
                "elements": [
                  {
                    "id": blog.fields.find_by_name('SEO Title').id
                  },
                  {
                    "id": blog.fields.find_by_name('SEO Keywords').id
                  },
                  {
                    "id": blog.fields.find_by_name('SEO Description').id
                  }
                ]
              },
              {
                "grid_width": 6,
                "elements": [
                  {
                    "id": blog.fields.find_by_name('No Index').id
                  },
                  {
                    "id": blog.fields.find_by_name('No Follow').id
                  },
                  {
                    "id": blog.fields.find_by_name('No Snippet').id
                  },
                  {
                    "id": blog.fields.find_by_name('No ODP').id
                  },
                  {
                    "id": blog.fields.find_by_name('No Archive').id
                  },
                  {
                    "id": blog.fields.find_by_name('No Image Index').id
                  }
                ]
              }
            ]
          }
        ]
      }

      blog_wizard_decorator = Decorator.new(name: "Wizard", data: wizard_hash)
      blog_wizard_decorator.save

      ContentableDecorator.create({
                                    decorator_id: blog_wizard_decorator.id,
                                    contentable_id: blog.id,
                                    contentable_type: 'ContentType'
                                  })

      puts "Creating Index Decorators..."
      index_hash = {
        "columns":
          [
            {
              "name": "Author",
              "grid_width": 2,
              "cells": [{
                          "field": {
                            "method": "author_image"
                          },
                          "display": {
                            "classes": [
                              "circular"
                            ]
                          }
                        }]
            },
            {
              "name": "Post Details",
              "cells": [
                {
                  "field": {
                    "id": blog.fields.find_by_name('Title').id
                  },
                  "display": {
                    "classes": [
                      "bold",
                      "upcase"
                    ]
                  }
                },
                {
                  "field": {
                    "id": blog.fields.find_by_name('Slug').id
                  }
                },
                {
                  "field": {
                    "method": "publish_state"
                  }
                }
              ]
            },
            {
              "name": "Tags",
              "cells": [
                {
                  "field": {
                    "id": blog.fields.find_by_name('Tags').id
                  },
                  "display": {
                    "classes": [
                      "tag",
                      "rounded"
                    ]
                  }
                }
              ]
            }
          ]
      }

      blog_index_decorator = Decorator.new(name: "Index", data: index_hash)
      blog_index_decorator.save

      ContentableDecorator.create({
                                    decorator_id: blog_index_decorator.id,
                                    contentable_id: blog.id,
                                    contentable_type: 'ContentType'
                                  })

      puts "Creating RSS Decorators..."
      rss_hash = {
        "channel": {
          "title": { "string": "Employer Blog" },
          "link": { "string": "https://hiring.careerbuilder.com/promotions/" },
          "description": { "string": "A Blog for Employers" },
          "category:1": { "string": "Employers" },
          "category:2": { "string": "Blog" },
          "docs": { "string": "https://admin.cbcortex.com/rss/v2/docs" },
          "ttl": { "string": "30" },
          "not_in_spec": { "string": "Should Not Be Included" }
        },
        "item": {
          "title": { "field": blog.fields.find_by_name('Title').id },
          "link": { "method": {
                      "name": "rss_url",
                      "args": ["https://hiring.careerbuilder.com/promotions/", blog.fields.find_by_name('Slug').id]
                   }
            },
          "description": { "field": blog.fields.find_by_name('Description').id },
          "content": { "field": blog.fields.find_by_name('Body').id, "encode": true },
          "author": { "method": {
                        "name": "user_email",
                        "args": [blog.fields.find_by_name('Author').id]
                      }
          },
          "category:1": { "field": blog.fields.find_by_name('Tags').id, "multiple": "," },
          # "category": { "field": blog.fields.find_by_name('Categories').id, "multiple": true }, Data not persisting, pending bugfix
          "guid": { "attributes": {
                      "isPermaLink": false
                    },
                    "method": { "name": "id" }
                  },
          "pubDate": { "field": blog.fields.find_by_name('Publish Date').id },
          "other_thing_that's_not_in_spec": { "string": "Should not appear in RSS Feed for Items" }
        }
      }

      blog_rss_decorator = Decorator.new(name: "Rss", data: rss_hash)
      blog_rss_decorator.save

      ContentableDecorator.create({
                                    decorator_id: blog_rss_decorator.id,
                                    contentable_id: blog.id,
                                    contentable_type: 'ContentType'
                                  })

      Rake::Task['plugin:demo:seed'].execute
    end
  end
end
