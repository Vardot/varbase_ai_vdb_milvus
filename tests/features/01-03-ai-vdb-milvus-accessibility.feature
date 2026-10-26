@varbase-ai-vdb-milvus @ai @recipes @a11y @local @development @staging @production
Feature: Varbase AI Recipe - AI VDB: Milvus - Accessible provider page
  As a site administrator who uses assistive technology
  I want the Milvus settings page to work with a keyboard and a screen reader
  So that I can manage the vector database like anyone else

  Scenario Outline: Check the Milvus provider page keeps the "<rule>" accessibility rule
    Given I am a logged in user with the "Webmaster" user
     When I go to "/admin/config/ai/vdb_providers/milvus"
     Then the page should not violate the accessibility rule "<rule>"

    Examples:
      | rule              |
      | label             |
      | link-name         |
      | duplicate-id-aria |
      | aria-valid-attr   |
