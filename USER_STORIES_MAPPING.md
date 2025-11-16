# User Stories Implementation Mapping

This document maps each user story to its implementation components.

## User Story 1: Registration and Data Access
**Implementation**: Existing authentication system
- Service: `AuthenticationService`
- Tables: `Users`, `SessionLogs`

## User Story 2: Login for Feedback
**Implementation**: Login with feedback access
- Service: `AuthenticationService`
- Views: `LoginWindow.xaml`

## User Story 3: Enter Applicant Information
**Implementation**: Complete
- Service: `ApplicantService`
- Model: `Applicant`
- Table: `Applicants`
- Methods: `AddApplicantAsync()`, `GetApplicantsBySessionUserAsync()`

## User Story 4: Select Templates
**Implementation**: Complete
- Service: `TemplateService`
- Model: `Template`, `TemplateSectionLink`
- Tables: `Templates`, `TemplateSectionLinks`
- Methods: `GetAllTemplatesAsync()`, `GetTemplateWithSectionsAsync()`

## User Story 5: Auto-delete on Logout
**Implementation**: CASCADE DELETE in database
- Table: `Applicants` (ON DELETE CASCADE)
- Trigger: User logout

## User Story 6: Reset Applicants
**Implementation**: Complete
- Service: `ApplicantService.DeleteAllApplicantsForSessionAsync()`

## User Story 7: Navigate Through Templates
**Implementation**: Complete
- Service: `FeedbackService.UpdateSectionIndexAsync()`
- Field: `FeedbackSessions.CurrentSectionIndex`

## User Story 8: View Available Codes
**Implementation**: Complete
- Service: `TemplateService.GetCodesBySectionAsync()`
- Model: `Code`
- Table: `Codes`

## User Story 10: Abort Feedback
**Implementation**: Complete
- Service: `FeedbackService.AbortFeedbackSessionAsync()`

## User Story 11: PDF and Bulk Email
**Implementation**: Complete
- Services: `PdfExportService`, `EmailService`
- Table: `CompletedFeedbacks`
- Methods: `ExportFeedbackToPdfAsync()`, `SendBulkFeedbackEmailsAsync()`

## User Story 12: Store Paragraphs
**Implementation**: Complete
- Service: `FeedbackParagraphService`
- Model: `FeedbackParagraph`
- Table: `FeedbackParagraphs`

## User Story 13: CRUD for Codes/Sections/Templates
**Implementation**: Complete
- Service: `TemplateService` (all CRUD methods)
- Methods: Add, Update, Delete for all entities

## User Story 14: Link Sections and Templates
**Implementation**: Complete
- Service: `TemplateService.LinkSectionToTemplateAsync()`
- Model: `TemplateSectionLink`
- Table: `TemplateSectionLinks`

## User Story 15: Access Health Information
**Implementation**: Complete
- Service: `HealthInformationService`
- Model: `HealthInformation`
- Table: `HealthInformation`
