# Technical Specification Template

## Executive Summary

[Provide a brief technical overview of the solution approach. Summarize main architectural decisions and implementation strategy in 1-2 paragraphs.]

## System Architecture

### Component Overview

[Brief description of main components and their responsibilities:

- Component names and primary functions
- Main relationships between components
- Data flow overview]

## Implementation Design

### Main Interfaces

[Define main service interfaces (≤20 lines per example):

```kotlin
// Example interface definition
interface ServiceName {
    suspend fun methodName(input: InputType): OutputType
}
```

]

### Data Models

[Define essential data structures:

- Main domain entities (if applicable)
- Request/response types
- Database schemas (if applicable)]

## Integration Points

[Include only if the feature requires external integrations:

- External services or APIs
- Authentication requirements
- Error handling approach]

## Development Sequencing

### Build Order

[Define implementation sequence:

1. First component/feature (why first)
2. Second component/feature (dependencies)
3. Subsequent components
4. Integration and testing]

### Technical Dependencies

[List any blocking dependencies:

- Required infrastructure
- External service availability]

## Technical Considerations

### Main Decisions

[Document important technical decisions:

- Approach choice and justification
- Trade-offs considered
- Rejected alternatives and why]

### Known Risks

[Identify technical risks:

- Potential challenges
- Mitigation approaches
- Areas needing research]

### Standards Compliance

[Review the rules in `AGENTS.md` and the relevant `.claude/skills/*/SKILL.md` files that apply to this techspec and list them below:]

### Relevant Files

[List relevant files here]
