--聖女的儀式
function c3030103.initial_effect(c)
	--Activate
	local e1=Effect.CreateEffect(c)
	e1:SetCategory(CATEGORY_POSITION+CATEGORY_SPECIAL_SUMMON)
	e1:SetType(EFFECT_TYPE_ACTIVATE)
	e1:SetCode(EVENT_FREE_CHAIN)
	e1:SetHintTiming(0,0x1e0)
	e1:SetTarget(c3030103.target)
	e1:SetOperation(c3030103.activate)
	c:RegisterEffect(e1)
end
function c3030103.target(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.IsExistingMatchingCard(Card.IsFacedown,tp,LOCATION_MZONE,LOCATION_MZONE,1,nil) end
	local g=Duel.GetMatchingGroup(Card.IsFacedown,tp,LOCATION_MZONE,LOCATION_MZONE,nil)
	Duel.SetOperationInfo(0,CATEGORY_POSITION,g,g:GetCount(),0,0)
end
function c3030103.activate(e,tp,eg,ep,ev,re,r,rp)
	local g=Duel.GetMatchingGroup(Card.IsFacedown,tp,LOCATION_MZONE,LOCATION_MZONE,nil)
	if g:GetCount()>0 then
		Duel.ChangePosition(g,POS_FACEUP_DEFENCE)
	end
	if chk==0 then return Duel.IsExistingMatchingCard(c3030103.sfilter,tp,LOCATION_MZONE,LOCATION_MZONE,1,nil) end
		local sg=Duel.GetMatchingGroup(c3030103.spfilter,tp,LOCATION_DECK,0,nil,e,tp)
		if sg:GetCount()>0 and Duel.SelectYesNo(tp,aux.Stringid(3030103,0)) then
			Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_SPSUMMON)
			Duel.SpecialSummon(sg:Select(tp,1,1,nil),0,tp,tp,false,false,POS_FACEUP)
		end
	local e1=Effect.CreateEffect(e:GetHandler())
	e1:SetType(EFFECT_TYPE_FIELD)
	e1:SetProperty(EFFECT_FLAG_PLAYER_TARGET+EFFECT_FLAG_OATH)
	e1:SetCode(EFFECT_CANNOT_BP)
	e1:SetReset(RESET_PHASE+PHASE_END)
	e1:SetTargetRange(1,0)
	Duel.RegisterEffect(e1,tp)
end
function c3030103.sfilter(c)
	return c:IsFaceup() and c:IsSetCard(0x3e1)
end
function c3030103.spfilter(c,e,tp)
	return c:IsCode(187199009)
		and c:IsCanBeSpecialSummoned(e,0,tp,false,false)
end

