We are build an android app in flutter.

The app is a countdown to special events in Penelope's life.
You can see from `main-screen-theme.jpg` that the app will have a glittery rainbow backdrop. And it will show a chip or card for every single day (the ones leading up and between special events). The app should initialize as the day when we first open it, and continue to show the same number of days from then on (almost like an epoch). On each day, you can click on a chip/card to tick them. At the very top of the screen there will be a color selector that shows 7 different colors. When you click on a color, ticking a day that has passed (or today) ticks it with that color. Future days cannot be ticked. The app will indicate which days can be ticked by showing a gold outline around them that should gimmmer slightly.

The app will intermingle the special days with the regular days, except the special days will be full-width cards like in `special-tiles.jpg`. These special days will say the name of the day, and show the big number for how many days until that day.

Thinking about it, since the regular days will stay "fixed" since epoch, maybe we should turn the "past" days into negative numbers, and the future days into positive numbers. So the day we open the app will be day 0, then when you open it the next day, that same chip will be -1, and the next day will be -2, etc. The future days will be 1, 2, 3, etc. This way we can easily calculate how many days until a special event by just looking at the number on the card.

You can scroll down and up the app to look far into the future up until new years day. THen on the next year it resets the epoch to the new year january 1st.

The special events that we want to include are:
- Penelopes birthday (May 28th)
- Christmas (December 25th)
- New Year's Eve (December 31st)
- New Year's Day (January 1st)
- Valentine's Day (February 14th)
- Easter (this will need to calculate the date of easter for each year, which is a bit tricky but there are algorithms for it, just try and bake int the next 10 years of easter dates into the app)
- Dads birthday (May 26th)
- Mums birthday (March 7th)
- Sia's birthday (September 7th)
- Caspians birthday (January 4th)
- Nannys birthday (August 29th)
- Opa's birthday (June 11th)
- Malee's birthday (September 29th)
- Dave's birthday (October 17th)

The images for each of the days are:
- Penelope: a disco ball
- Christmas: a baby jesus in a manger
- New Year's Eve: fireworks
- New Year's Day: a party hat
- Valentine's Day: a love heart
- Easter: a cross
- Dad: video game controller
- Mum: a lady walking at the beach
- Sia: cartoon kids playing together
- Caspian: toy cars
- Nanny: a grandma cooking custard
- Opa: an old man sleeping
- Malee: a coffee cup
- Dave: an ice cream

The images should be a cartoon style and share the same style between them all. We will show them as backdrops for the special day cards, but they will have a slight opacity so that the text and numbers can be easily read on top of them. The regular day chips will not have any images, just the number of days until or since the epoch.


To generate images, use the replicate API with the ideogram-ai/ideogram-v3-turbo model.
To generate videos, use the replicate API with the wan-video/wan-2.2-i2v-fast model.

Example image generation curl:

curl -s -X POST \
  -H "Authorization: Bearer $REPLICATE_API_TOKEN" \
  -H "Content-Type: application/json" \
  -H "Prefer: wait" \
  -d $'{
    "input": {
      "prompt": "The text \\"V3 Turbo\\" in the center middle. A color film-inspired portrait of a young man looking to the side with a shallow depth of field that blurs the surrounding elements, drawing attention to his eye. The fine grain and cast suggest a high ISO film stock, while the wide aperture lens creates a motion blur effect, enhancing the candid and natural documentary style.",
      "resolution": "None",
      "style_type": "None",
      "aspect_ratio": "3:2",
      "style_preset": "None",
      "magic_prompt_option": "Auto"
    }
  }' \
  https://api.replicate.com/v1/models/ideogram-ai/ideogram-v3-turbo/predictions
