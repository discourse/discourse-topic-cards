{{!-- has-modern-replacement --}}
{{! template-lint-disable deprecated-inline-view-helper }}
  {{#if view.hasThumbnail}}
    <div class="topic-card__thumbnail">
  {{else}}
    <div class="no-thumbnail">
  {{/if}}
      <a href="{{view.url}}">
        {{#if view.hasThumbnail}}
          <img
            class="main-thumbnail"
            src="{{view.fallbackSrc}}"
            srcset="{{view.srcSet}}"
            width={{view.width}}
            height={{view.height}}
            loading="lazy"
          >
        {{/if}}
      </a>
  </div>

