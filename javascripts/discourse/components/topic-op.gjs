import { and, not } from "truth-helpers";
import UserLink from "discourse/components/user-link";
import avatar from "discourse/helpers/avatar";

const TopicOp = <template>
  <div class="topic-card__op">
    <UserLink @user={{@topic.creator}}>
      {{avatar @topic.creator imageSize="tiny"}}
      <span class="username">
        {{#if
          (and
            @topic.creator.name
            (not this.siteSettings.prioritize_username_in_ux)
          )
        }}
          {{@topic.creator.name}}
        {{else}}
          {{@topic.creator.username}}
        {{/if}}
      </span>
    </UserLink>
  </div>
</template>;

export default TopicOp;
