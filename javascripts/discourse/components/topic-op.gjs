import UserLink from "discourse/components/user-link";
import avatar from "discourse/helpers/avatar";

const TopicOp = <template>
  <div class="topic-card__op">
    <UserLink @user={{@topic.creator}}>
      {{avatar @topic.creator imageSize="tiny"}}
      <span class="username">
        {{@topic.creator.username}}
      </span>
    </UserLink>
  </div>
</template>;

export default TopicOp;
