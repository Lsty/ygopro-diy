--Black¡ïSwitch
function c20121162.initial_effect(c)
	--Activate
	local e1=Effect.CreateEffect(c)
	e1:SetCategory(CATEGORY_TOHAND+CATEGORY_SPECIAL_SUMMON)
	e1:SetProperty(EFFECT_FLAG_CARD_TARGET)
	e1:SetType(EFFECT_TYPE_ACTIVATE)
	e1:SetCode(EVENT_FREE_CHAIN)
	e1:SetCost(c20121162.cost)
	e1:SetTarget(c20121162.target)
	e1:SetOperation(c20121162.activate)
	c:RegisterEffect(e1)
end
function c20121162.cost(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.GetFlagEffect(tp,20121162)==0 end
	Duel.RegisterFlagEffect(tp,20121162,RESET_PHASE+PHASE_END,0,1)
end
function c20121162.filter(c)
	return c:IsAbleToHand()
end
function c20121162.target(e,tp,eg,ep,ev,re,r,rp,chk,chkc)
	if chkc then return chkc:IsLocation(LOCATION_MZONE) and chkc:IsControler(tp) and c20121162.filter(chkc) end
	if chk==0 then return Duel.IsExistingTarget(c20121162.filter,tp,LOCATION_MZONE,0,1,nil)
		and Duel.IsExistingMatchingCard(c20121162.sumfilter,tp,LOCATION_HAND,0,1,nil,e,tp) end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_RTOHAND)
	local g=Duel.SelectTarget(tp,c20121162.filter,tp,LOCATION_MZONE,0,1,1,nil)
	Duel.SetOperationInfo(0,CATEGORY_TOHAND,g,1,0,0)
	Duel.SetOperationInfo(0,CATEGORY_SPECIAL_SUMMON,nil,1,tp,LOCATION_HAND)
end
function c20121162.sumfilter(c,e,tp)
	return c:IsAttribute(ATTRIBUTE_DARK) and c:IsRace(RACE_WARRIOR) and c:IsCanBeSpecialSummoned(e,0,tp,false,false)
end
function c20121162.tfilter(c,lv,e,tp)
	return c:IsSetCard(0x777) and c:GetLevel()==lv and c:IsCanBeSpecialSummoned(e,0,tp,false,false) and not c:IsHasEffect(EFFECT_NECRO_VALLEY)
end
function c20121162.activate(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	local tc=Duel.GetFirstTarget()
	if tc:IsRelateToEffect(e) and Duel.SendtoHand(tc,nil,REASON_EFFECT)>0 and tc:IsLocation(LOCATION_HAND+LOCATION_EXTRA) then
		if Duel.IsExistingMatchingCard(c20121162.sumfilter,tp,LOCATION_HAND,0,1,nil,e,tp) then
			Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_SPSUMMON)
			local g=Duel.SelectMatchingCard(tp,c20121162.sumfilter,tp,LOCATION_HAND,0,1,1,nil,e,tp)
			if g:GetCount()>0 and Duel.SpecialSummon(g,0,tp,tp,false,false,POS_FACEUP)~=0 then
				if Duel.IsExistingMatchingCard(c20121162.tfilter,tp,LOCATION_GRAVE,0,1,nil,g:GetFirst():GetLevel(),e,tp) and Duel.GetLocationCount(tp,LOCATION_MZONE)>0
					and Duel.SelectYesNo(tp,aux.Stringid(20121162,0)) then
					Duel.BreakEffect()
					Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_SPSUMMON)
					local g1=Duel.SelectMatchingCard(tp,c20121162.tfilter,tp,LOCATION_GRAVE,0,1,1,nil,g:GetFirst():GetLevel(),e,tp)
					Duel.SpecialSummon(g1,0,tp,tp,false,false,POS_FACEUP)
				end
			end
		end
	end
end