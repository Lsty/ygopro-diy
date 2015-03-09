--戏言·死线之蓝·玖渚友
function c24600001.initial_effect(c)
	--end battle phase
	local e1=Effect.CreateEffect(c)
	e1:SetCategory(CATEGORY_SPECIAL_SUMMON)
	e1:SetType(EFFECT_TYPE_QUICK_O)
	e1:SetCode(EVENT_ATTACK_ANNOUNCE)
	e1:SetRange(LOCATION_HAND)
	e1:SetCondition(c24600001.condition)
	e1:SetCost(c24600001.cost)
	e1:SetOperation(c24600001.operation)
	c:RegisterEffect(e1)
end
function c24600001.condition(e,tp,eg,ep,ev,re,r,rp)
	local at=Duel.GetAttacker()
	return at:GetControler()~=tp
end
function c24600001.cost(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return e:GetHandler():IsDiscardable() end
	Duel.SendtoGrave(e:GetHandler(),REASON_COST+REASON_DISCARD)
end
function c24600001.sumfilter(c,e,tp)
	return c:IsSetCard(0x246) and c:IsLevelBelow(4) and c:GetCode()~=24600001 and c:IsCanBeSpecialSummoned(e,0,tp,false,false)
end
function c24600001.operation(e,tp,eg,ep,ev,re,r,rp)
	if Duel.NegateAttack() and Duel.GetLocationCount(tp,LOCATION_MZONE)>0 and Duel.IsExistingMatchingCard(c24600001.sumfilter,tp,LOCATION_GRAVE,0,1,nil,e,tp)
		and Duel.SelectYesNo(tp,aux.Stringid(24600001,0))then
		Duel.BreakEffect()
		Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_SPSUMMON)
		local g=Duel.SelectMatchingCard(tp,c24600001.sumfilter,tp,LOCATION_GRAVE,0,1,1,nil,e,tp)
		Duel.HintSelection(g)
		Duel.SpecialSummon(g,0,tp,tp,false,false,POS_FACEUP)
	end
end