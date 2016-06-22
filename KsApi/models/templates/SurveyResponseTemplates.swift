extension SurveyResponse {
  internal static let template = SurveyResponse(
    answeredAt: nil,
    id: 1,
    project: .template,
    urls: SurveyResponse.UrlsEnvelope(
      web: SurveyResponse.UrlsEnvelope.WebEnvelope(
        survey: "http://www.surveys.com"
      )
    )
  )
}
