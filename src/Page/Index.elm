module Page.Index exposing (Data, Model, Msg, page)

import Css exposing (alignItems, backgroundColor, block, center, display, displayFlex, flex, height, justifyContent, padding2, pct, spaceAround, textAlign, width, zero)
import Css.Media as Media exposing (only, screen, withMedia)
import DataSource exposing (DataSource)
import Head
import Head.Seo as Seo
import Html.Styled exposing (..)
import Html.Styled.Attributes exposing (alt, css, href, src)
import Page exposing (Page, StaticPayload)
import Pages.PageUrl exposing (PageUrl)
import Pages.Url
import Route exposing (Route)
import Shared
import Styles
import View exposing (View)


type alias Model =
    ()


type alias Msg =
    Never


type alias RouteParams =
    {}


page : Page RouteParams Data
page =
    Page.singleRoute
        { head = head
        , data = data
        }
        |> Page.buildNoState { view = view }


data : DataSource Data
data =
    DataSource.succeed ()


head :
    StaticPayload Data RouteParams
    -> List Head.Tag
head static =
    Seo.summary
        { canonicalUrlOverride = Nothing
        , siteName = "Out of Our Minds"
        , image =
            { url = Pages.Url.external "/images/logo-main.svg"
            , alt = "Out of Our Minds logo"
            , dimensions = Nothing
            , mimeType = Nothing
            }
        , description = "Create resources bringing order out of chaos for families"
        , locale = Nothing
        , title = "Out of Our Minds"
        }
        |> Seo.website


type alias Data =
    ()


view :
    Maybe PageUrl
    -> Shared.Model
    -> StaticPayload Data RouteParams
    -> View Msg
view maybeUrl sharedModel static =
    { title = "Out of Our Minds"
    , body =
        [ header []
            [ link Route.Index [] [ img [ src "/images/logo-main.svg", alt "Out of Our Minds" ] [] ]
            ]
        , main_ []
            [ section []
                [ img [ css [ width (pct 100), padding2 zero (Css.em 2) ], src "/images/tagline.svg", alt "Creative resources bringing order to chaos for families" ] []
                ]
            , section [ css [ displayFlex, justifyContent spaceAround, alignItems center, height (Css.em 10) ] ]
                [ a [ css [ display block, textAlign center, backgroundColor Styles.palette.primary ], href "" ] [ text "Articles" ]
                , a [ css [ display block, textAlign center, backgroundColor Styles.palette.secondary ], href "" ] [ text "Store" ]
                ]
            , section [ css [ logoNavStyles ] ] (List.map viewCategoryLink static.sharedData.categories)
            ]
        , footer [] []
        ]
    }


viewCategoryLink : Shared.Category -> Html msg
viewCategoryLink category =
    a [ css [ textAlign center ], href "" ] [ img [ src category.icon, alt category.name ] [] ]


logoNavStyles : Css.Style
logoNavStyles =
    Css.batch
        [ Css.property "display" "grid"
        , Css.property "grid-gap" "1em"
        , Css.property "grid-template-columns" " 1fr"
        , withMedia [ only screen [ Media.minWidth (Css.px 300), Media.maxWidth (Css.px 449) ] ]
            [ Css.property "grid-template-columns" "repeat(2, 1fr)"
            ]
        , withMedia [ only screen [ Media.minWidth (Css.px 450), Media.maxWidth (Css.px 959) ] ]
            [ Css.property "grid-template-columns" "repeat(3, 1fr)"
            ]
        , withMedia [ only screen [ Media.minWidth (Css.px 960) ] ]
            [ Css.property "grid-template-columns" "repeat(6, 1fr)"
            ]
        ]


link : Route -> List (Attribute msg) -> List (Html msg) -> Html msg
link route attributes children =
    Route.toLink
        (\anchorAttrs ->
            a (List.map Html.Styled.Attributes.fromUnstyled anchorAttrs ++ attributes) children
        )
        route
