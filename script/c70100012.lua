--正体不明的紫镜
function c70100012.initial_effect(c)
	--Activate
	local e1=Effect.CreateEffect(c)
	e1:SetType(EFFECT_TYPE_ACTIVATE)
	e1:SetCode(EVENT_FREE_CHAIN)
	e1:SetCategory(CATEGORY_SPECIAL_SUMMON+CATEGORY_TOGRAVE)
	e1:SetCost(c70100012.spcost)
	e1:SetTarget(c70100012.target)
	e1:SetOperation(c70100012.activate)
	c:RegisterEffect(e1)
end
function c70100012.spcost(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.GetFlagEffect(tp,70100012)==0 end
	Duel.RegisterFlagEffect(tp,70100012,RESET_PHASE+PHASE_END,0,1)
	local e1=Effect.CreateEffect(e:GetHandler())
	e1:SetType(EFFECT_TYPE_FIELD)
	e1:SetCode(EFFECT_AVOID_BATTLE_DAMAGE)
	e1:SetProperty(EFFECT_FLAG_PLAYER_TARGET)
	e1:SetTargetRange(0,1)
	e1:SetValue(1)
	e1:SetReset(RESET_PHASE+PHASE_END)
	Duel.RegisterEffect(e1,tp)
end
function c70100012.target(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.IsPlayerCanDiscardDeck(tp,2) end
	Duel.SetOperationInfo(0,CATEGORY_DECKDES,nil,0,tp,2)
end
function c70100012.spfilter(c,e,tp)
	return c:IsSetCard(0x701) and c:IsLevelBelow(4) and c:IsCanBeSpecialSummoned(e,0,tp,false,false) and not c:IsHasEffect(EFFECT_NECRO_VALLEY)
end
function c70100012.activate(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	if Duel.GetFieldGroupCount(tp,LOCATION_DECK,0)<=1 then return end
	Duel.DiscardDeck(tp,2,REASON_EFFECT)
	local sg=Duel.GetMatchingGroup(c70100012.spfilter,tp,LOCATION_GRAVE,0,nil,e,tp)
	if sg:GetCount()>0 then
		Duel.BreakEffect()
		Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_SPSUMMON)
		local g=sg:Select(tp,1,1,nil)
		local tc=g:GetFirst()
		Duel.SpecialSummon(g,0,tp,tp,false,false,POS_FACEUP)
	end
end
