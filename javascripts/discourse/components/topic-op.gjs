import Component from "@glimmer/component";
import UserLink from "discourse/components/user-link";
import avatar from "discourse/helpers/avatar";
import { prioritizeNameInUx } from "discourse/lib/settings";

export default class TopicOp extends Component {
  get creatorName() {
    const creator = this.args.topic.creator;

    if (prioritizeNameInUx(creator?.name)) {
      return creator.name;
    }

    return creator?.username;
  }

  <template>
    <div class="topic-card__op">
      <UserLink @user={{@topic.creator}}>
        {{avatar @topic.creator imageSize="tiny"}}
        <span class="username">
          {{this.creatorName}}
        </span>
      </UserLink>
    </div>
  </template>
}
