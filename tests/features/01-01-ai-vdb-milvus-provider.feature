@varbase-ai-vdb-milvus @ai @recipes @local @development @staging @production
Feature: Varbase AI Recipe - AI VDB: Milvus - The site connects to a Milvus vector database
  As a site builder
  I want the site connected to the Milvus vector database, with its key kept out of the configuration
  So that Varbase AI Search can store and search vectors in Milvus

  Background:
    Given I am a logged in user with the "Webmaster" user

  Scenario: Verify the webmaster saves the Milvus connection without an error
     When I go to "/admin/config/ai/vdb_providers/milvus"
      And I press "Save configuration"
     Then I should see "The configuration options have been saved."

  Scenario: Check the Milvus API key is kept with the site's keys
     When I go to "/admin/config/system/keys"
     Then I should see "Milvus API key"
