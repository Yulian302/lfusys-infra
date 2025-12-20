
```mermaid

flowchart LR
    FE["React Frontend"] <-- HTTP --> GW["Gateway"]
    GW <-- gRPC --> US["Sessions Service"]
    US --> DDB1[("DynamoDB Uploads")]
    GW --> DDB2[("DynamoDB Users")]
    FE <-- HTTP --> UW["Upload Service"]
    UW --> S3[("S3 Object Storage")]