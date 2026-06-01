import ActivityCell from "discourse/components/topic-list/item/activity-cell";
import RepliesCell from "discourse/components/topic-list/item/replies-cell";
import ViewsCell from "discourse/components/topic-list/item/views-cell";
import formatDate from "discourse/helpers/format-date";
import { i18n } from "discourse-i18n";
import LikeToggle from "./like-toggle";

const TopicMetadata = <template>
  <div class="topic-card__metadata">
    {{#if settings.show_publish_date}}
      <span class="topic-card__publish-date">
        {{i18n (themePrefix "published")}}
        {{formatDate @topic.createdAt format="medium-with-ago"}}
      </span>
    {{/if}}

    <div class="right-aligned">
      <table class="topic-card__stats">
        <tr>
          {{#if settings.show_views}}
            <ViewsCell @topic={{@topic}} />
          {{/if}}

          {{#if settings.show_likes}}
            <td class="num topic-list-data topic-card__likes">
              <LikeToggle @topic={{@topic}} />
            </td>
          {{/if}}

          {{#if settings.show_reply_count}}
            <RepliesCell @topic={{@topic}} />
          {{/if}}

          {{#if settings.show_activity}}
            <ActivityCell @topic={{@topic}} />
          {{/if}}
        </tr>
      </table>
    </div>
  </div>
</template>;

export default TopicMetadata;
