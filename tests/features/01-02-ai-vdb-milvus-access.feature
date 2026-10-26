@varbase-ai-vdb-milvus @ai @recipes @access @local @development @staging @production
Feature: Varbase AI Recipe - AI VDB: Milvus - Who can see the Milvus connection
  As a site owner
  I want only the super administrator to see the Milvus server and key settings
  So that the vector database address and credentials are not shown to anyone else

  Scenario Outline: Check the "<user>" user cannot open the Milvus provider settings
    Given I am a logged in user with the "<user>" user
     When I go to "/admin/config/ai/vdb_providers/milvus"
     Then the response status code should be 403
      And I should see "Access denied"

    Examples:
      | user           |
      | Content editor |
      | Content admin  |
      | SEO admin      |
      | Site admin     |

  Scenario: Check an anonymous visitor cannot open the Milvus provider settings
    Given I am an anonymous user
     When I go to "/admin/config/ai/vdb_providers/milvus"
     Then the response status code should be 403
      And I should not see "Public Endpoint"
