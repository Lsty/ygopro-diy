--量子变换器
function c12400022.initial_effect(c)
	--Activate
	local e1=Effect.CreateEffect(c)
	e1:SetCategory(CATEGORY_DESTROY+CATEGORY_SPECIAL_SUMMON)
	e1:SetType(EFFECT_TYPE_ACTIVATE)
	e1:SetProperty(EFFECT_FLAG_CARD_TARGET)
	e1:SetCode(EVENT_FREE_CHAIN)
	e1:SetCost(c12400022.cost)
	e1:SetTarget(c12400022.target)
	e1:SetOperation(c12400022.activate)
	c:RegisterEffect(e1)
end
function c12400022.cost(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.GetFlagEffect(tp,12400022)==0 end
	Duel.RegisterFlagEffect(tp,12400022,RESET_PHASE+PHASE_END,EFFECT_FLAG_OATH,1)
end
function c12400022.filter(c,e,tp)
	local lv=c:GetLevel()
	local def=c:GetDefence()
	return lv>0 and c:IsRace(RACE_FAIRY) and c:IsFaceup() and c:IsDestructable()
		and Duel.IsExistingMatchingCard(c12400022.spfilter,tp,LOCATION_DECK,0,1,nil,lv,def,e,tp)
end
function c12400022.spfilter(c,lv,def,e,tp)
	return c:IsLevelBelow(lv) and c:GetDefence()==def and c:IsRace(RACE_FAIRY) and c:IsCanBeSpecialSummoned(e,0,tp,false,false)
end
function c12400022.target(e,tp,eg,ep,ev,re,r,rp,chk,chkc)
	if chkc then return chkc:IsLocation(LOCATION_MZONE) and chkc:IsControler(tp) and c12400022.filter(chkc) end
	if chk==0 then return Duel.GetLocationCount(tp,LOCATION_MZONE)>-1
		and Duel.IsExistingTarget(c12400022.filter,tp,LOCATION_MZONE,0,1,nil,e,tp) end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_DESTROY)
	local g=Duel.SelectTarget(tp,c12400022.filter,tp,LOCATION_MZONE,0,1,1,nil,e,tp)
	Duel.SetOperationInfo(0,CATEGORY_DESTROY,g,1,0,0)
	Duel.SetOperationInfo(0,CATEGORY_SPECIAL_SUMMON,nil,1,tp,LOCATION_DECK)
end
function c12400022.activate(e,tp,eg,ep,ev,re,r,rp)
	local tc=Duel.GetFirstTarget()
	local lv=tc:GetLevel()
	local def=tc:GetDefence()
	if tc:IsRelateToEffect(e) then
		if Duel.Destroy(tc,REASON_EFFECT)>0 then
			Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_SPSUMMON)
			local g=Duel.SelectMatchingCard(tp,c12400022.spfilter,tp,LOCATION_DECK,0,1,1,nil,lv,def,e,tp)
			if g:GetCount()>0 then
				Duel.SpecialSummon(g,0,tp,tp,false,false,POS_FACEUP)
			end
		end
	end
end
