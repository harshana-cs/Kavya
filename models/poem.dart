// lib/models/poem.dart
//
// WHY THIS FILE EXISTS:
// A "model" is just a plain class that describes a piece of data. It has
// no widgets, no UI — it's the shape of the information the app moves
// around. Every screen (feed, detail, drafts) talks about "a Poem", so we
// define what that word means exactly once, here.

enum PoemStatus { draft, published, scheduled }

class Poem {
  final String id;
  final String authorName;
  final String authorHandle;

  final String title;
  final String body;

  /// 'ne' for Nepali, 'en' for English. The card/detail screens use this
  /// to decide which Google Font to render the text in.
  final String language;

  final int likes;
  final int comments;
  final String timeAgo;

  /// Whether this poem has a voice/video reading attached, and if so,
  /// how long it is (shown as e.g. "1:12" in the UI).
  final bool hasAudio;
  final String? audioDuration;

  final PoemStatus status;

  const Poem({
    required this.id,
    required this.authorName,
    required this.authorHandle,
    required this.title,
    required this.body,
    required this.language,
    this.likes = 0,
    this.comments = 0,
    this.timeAgo = '',
    this.hasAudio = false,
    this.audioDuration,
    this.status = PoemStatus.published,
  });

  /// `copyWith` is a very common Dart pattern for "make a new object that's
  /// the same as this one, except for the fields I pass in." Since Poem's
  /// fields are all `final` (unchangeable after creation), this is how we
  /// produce an updated version — e.g. incrementing the like count.
  Poem copyWith({
    int? likes,
    int? comments,
    PoemStatus? status,
  }) {
    return Poem(
      id: id,
      authorName: authorName,
      authorHandle: authorHandle,
      title: title,
      body: body,
      language: language,
      likes: likes ?? this.likes,
      comments: comments ?? this.comments,
      timeAgo: timeAgo,
      hasAudio: hasAudio,
      audioDuration: audioDuration,
      status: status ?? this.status,
    );
  }
}

/// A comment on a poem. Kept separate from Poem itself so the detail
/// screen can hold a growing list of these.
class PoemComment {
  final String authorName;
  final String text;

  const PoemComment({required this.authorName, required this.text});
}

/// Some sample data so every screen has something real to render while
/// you build. In a finished app this would come from Firestore/your API
/// instead — see README "Next steps: connecting a backend".
final samplePoems = <Poem>[
  const Poem(
    id: '1',
    authorName: 'Aasha Thapa',
    authorHandle: '@aashathapa',
    title: 'Tea at Dawn',
    body:
        'The kettle hums a small blue song,\nand morning fizzles itself\ninto the cup I forgot to drink.',
    language: 'en',
    likes: 128,
    comments: 14,
    timeAgo: '3h',
  ),
  const Poem(
    id: '2',
    authorName: 'Bikram Rai',
    authorHandle: '@bikram.rai',
    title: 'साँझ',
    body:
        'साँझ ढल्दै छ बिस्तारै,\nपहाडको काखमा घाम लुक्यो ।\nमनको कुनै कुनामा,\nएउटा पुरानो गीत बाँकी छ ।',
    language: 'ne',
    likes: 93,
    comments: 8,
    hasAudio: true,
    audioDuration: '1:12',
    timeAgo: '5h',
  ),
];
