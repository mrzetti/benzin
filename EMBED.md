# RammWiki embed

Compact view: https://benzin.rammwiki.mrzetti.com/?embed=1

```html
<iframe src="https://benzin.rammwiki.mrzetti.com/?embed=1"
  title="Play Rammstein's Benzin game" width="100%" height="680"
  style="border:0" allow="autoplay; fullscreen" allowfullscreen
  loading="lazy"></iframe>
```

The view fits the iframe height and includes volume, fullscreen, restart and a
link to the full site. Touch devices also get steering, brake and gas buttons
below the playfield, with a toolbar toggle and simultaneous-touch support.
The external leaderboard and article-style presentation
are hidden. MediaWiki needs an administrator-configured widget or embedding
extension; raw iframe markup is generally not accepted in article wikitext.

`node tests/browser/embed.cjs` verifies loading inside a cross-site iframe,
desktop/narrow layout and volume. It does not verify score submission.

## Player identity and scores

Scores are already stored server-side in SQLite. The HttpOnly player cookie
identifies the owner of a personal best. It currently uses SameSite=Lax and
will not accompany requests inside a cross-site RammWiki iframe. The compact
view does not change that policy or claim embedded submissions work.

Recommended deployment: serve the game and API together at an HTTPS hostname
such as `games.rammwiki.net`. When embedded by HTTPS RammWiki pages, it is
same-site, allowing the existing host-only cookie design. This requires DNS,
TLS, nginx and backend origin configuration. Existing cookies from the old
hostname do not automatically migrate. The same score database can be retained.

RammWiki-account identity is a separate integration: a MediaWiki extension could
authenticate the player and bind a game profile to the verified wiki user ID.
Do not trust usernames passed by iframe query parameters. No wiki-side changes
have been made here.

Changing to localStorage on the current cross-site host is not a reliable
solution: embedded storage can also be blocked or partitioned. SameSite=None
alone does not overcome browsers' third-party-cookie blocking.
