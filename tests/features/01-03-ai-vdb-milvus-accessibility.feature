@varbase-ai-vdb-milvus @ai @recipes @a11y @local @development @staging @production
Feature: Varbase AI Recipe - AI VDB: Milvus - Accessible provider page
  As a site administrator who uses assistive technology
  I want the Milvus settings page to work with a keyboard and a screen reader
  So that I can manage the vector database like anyone else

  Scenario: Check the Milvus provider page gives every field a label and every link a name
    Given I am a logged in user with the "Webmaster" user
     When I go to "/admin/config/ai/vdb_providers/milvus"
     Then every form field should have an accessible label
      And every link should have an accessible name
      And every ARIA role should be valid
