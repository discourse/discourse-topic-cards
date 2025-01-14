import dirSpan from "discourse/helpers/dir-span";

const TopicExcerpt = <template>
  <div class="topic-card__excerpt">
    <div class="topic-card__excerpt-text">
      {{dirSpan @topic.escapedExcerpt htmlSafe="true"}}
    </div>
  </div>
</template>;

export default TopicExcerpt;
