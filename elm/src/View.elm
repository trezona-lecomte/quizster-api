module View (..) where

import Html exposing (..)
import Actions exposing (..)
import Models exposing (..)
import Routing
import Quiz.Models exposing (QuizId)
import Quiz.List exposing (view)
import Quiz.View

view : Signal.Address Action -> AppModel -> Html
view address model =
  let
    _ = Debug.log "model" model
  in
    div
      []
      [ page address model ]

page : Signal.Address Action -> AppModel -> Html.Html
page address model =
  case model.routing.route of
    Routing.QuizzesRoute ->
      quizzesPage address model

    Routing.QuizRoute quizId ->
      quizPage address model quizId

    Routing.NotFoundRoute ->
      notFoundView

quizzesPage : Signal.Address Action -> AppModel -> Html.Html
quizzesPage address model =
  let
    viewModel = { quizzes = model.quizzes }
  in
    Quiz.List.view (Signal.forwardTo address QuizAction) viewModel

quizPage : Signal.Address Action -> AppModel -> QuizId -> Html.Html
quizPage address model quizId =
  let
    maybeQuiz =
      model.quizzes
        |> List.filter (\quiz -> quiz.quizId == quizId)
        |> List.head
  in
    case maybeQuiz of
      Just quiz ->
        let
          viewModel = { quiz = quiz }
        in
          Quiz.View.view (Signal.forwardTo address QuizAction) viewModel
      Nothing ->
        notFoundView

notFoundView :Html.Html
notFoundView =
  div
    []
    [ text "Not Found"
    ]
