--战斗热舞！
function c999989018.initial_effect(c)
	--activate
	local e1=Effect.CreateEffect(c)
	e1:SetType(EFFECT_TYPE_ACTIVATE)
	e1:SetCode(EVENT_FREE_CHAIN)
	e1:SetProperty(EFFECT_FLAG_CARD_TARGET)
	e1:SetCountLimit(1,999989018+EFFECT_COUNT_CODE_OATH)
	e1:SetTarget(c999989018.tg1)
	e1:SetOperation(c999989018.op)
	c:RegisterEffect(e1)
	--
	local e2=Effect.CreateEffect(c)
	e2:SetDescription(aux.Stringid(999999,3))
	e2:SetType(EFFECT_TYPE_QUICK_O)
	e2:SetProperty(EFFECT_FLAG_CARD_TARGET)
	e2:SetRange(LOCATION_SZONE)
	e2:SetCode(EVENT_FREE_CHAIN)
	e2:SetCountLimit(1,999989018+EFFECT_COUNT_CODE_OATH)
	e2:SetCondition(c999989018.condition)
	e2:SetTarget(c999989018.tg2)
	e2:SetOperation(c999989018.op)
	c:RegisterEffect(e2)
end
function c999989018.condition(e,tp,eg,ep,ev,re,r,rp)
	return Duel.GetCurrentPhase()==PHASE_BATTLE
end
function c999989018.filter1(c)
	return c:IsFaceup() and c:IsSetCard(0x990) or c:IsCode(26016357) or c:IsSetCard(0xaabb)
end
function c999989018.filter2(c,e,tp)
	return c:IsFaceup() and c:IsSetCard(0x990) or c:IsCode(26016357) or c:IsSetCard(0xaabb) and c:IsAbleToHand()
end
function c999989018.filter3(c,e,tp)
	return  c:IsSetCard(0x990) or c:IsCode(26016357) or c:IsSetCard(0xaabb) and c:IsCanBeSpecialSummoned(e,0,tp,false,false)
end
function c999989018.tg1(e,tp,eg,ep,ev,re,r,rp,chk)
    if chk==0 then return true end
	local b1=Duel.IsExistingTarget(c999989018.filter1,tp,LOCATION_MZONE,0,1,nil)
		and Duel.IsExistingMatchingCard(nil,tp,0,LOCATION_MZONE,1,nil)
	local b2=Duel.IsExistingTarget(c999989018.filter2,tp,LOCATION_MZONE,0,1,nil) and  Duel.GetLocationCount(tp,LOCATION_MZONE)>-1
	if Duel.GetCurrentPhase()==PHASE_BATTLE
		and (b1 or b2) and Duel.SelectYesNo(tp,aux.Stringid(37055344,3)) then
	local op=0
	if b1 and b2   then
		op=Duel.SelectOption(tp,aux.Stringid(11613567,1),aux.Stringid(999997,8))
	elseif b1 then
		op=Duel.SelectOption(tp,aux.Stringid(11613567,1))
	else
		op=Duel.SelectOption(tp,aux.Stringid(999997,8))+1
	end
	e:SetLabel(op)
	if op==0 then
		Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_FACEUP)
		local g=Duel.SelectTarget(tp,c999989018.filter1,tp,LOCATION_MZONE,0,1,1,nil)  
		Duel.SetOperationInfo(0,CATEGORY_POSITION,g,1,0,0)
	else
		Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_RTOHAND)
		local g=Duel.SelectTarget(tp,c999989018.filter2,tp,LOCATION_MZONE,0,1,1,nil)
		Duel.SetOperationInfo(0,CATEGORY_TOHAND,g,1,0,0)
		Duel.SetOperationInfo(0,CATEGORY_SPECIAL_SUMMON,nil,1,0,0)
	end
	e:GetHandler():RegisterFlagEffect(999989018,RESET_EVENT+0x1fe0000+RESET_PHASE+PHASE_END,0,1)
    e:SetProperty(EFFECT_FLAG_PLAYER_TARGET)
	else
	e:SetProperty(0)
end
end
function c999989018.tg2(e,tp,eg,ep,ev,re,r,rp,chk)
	  if chk==0 then return true end
	local b1=Duel.IsExistingTarget(c999989018.filter1,tp,LOCATION_MZONE,0,1,nil)
		and Duel.IsExistingMatchingCard(nil,tp,0,LOCATION_MZONE,1,nil)
	local b2=Duel.IsExistingTarget(c999989018.filter2,tp,LOCATION_MZONE,0,1,nil) and  Duel.GetLocationCount(tp,LOCATION_MZONE)>-1
	local op=0
	if b1 and b2   then
		op=Duel.SelectOption(tp,aux.Stringid(11613567,1),aux.Stringid(999997,8))
	elseif b1 then
		op=Duel.SelectOption(tp,aux.Stringid(11613567,1))
	else
		op=Duel.SelectOption(tp,aux.Stringid(999997,8))+1
	end
	e:SetLabel(op)
	if op==0 then
		Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_FACEUP)
		local g=Duel.SelectTarget(tp,c999989018.filter1,tp,LOCATION_MZONE,0,1,1,nil)  
		Duel.SetOperationInfo(0,CATEGORY_POSITION,g,1,0,0)
	else
		Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_RTOHAND)
		local g=Duel.SelectTarget(tp,c999989018.filter2,tp,LOCATION_MZONE,0,1,1,nil)
		Duel.SetOperationInfo(0,CATEGORY_TOHAND,g,1,0,0)
		Duel.SetOperationInfo(0,CATEGORY_SPECIAL_SUMMON,nil,1,0,0)
	end
	e:GetHandler():RegisterFlagEffect(999989018,RESET_EVENT+0x1fe0000+RESET_PHASE+PHASE_END,0,1)
 end
function c999989018.op(e,tp,eg,ep,ev,re,r,rp)
	if e:GetHandler():GetFlagEffect(999989018)==0 or not e:GetHandler():IsRelateToEffect(e) then return end
		local tc=Duel.GetFirstTarget()
	if e:GetLabel()==0 then
		if not tc:IsRelateToEffect(e) or tc:IsFacedown() then return end
	    if Duel.ChangePosition(tc,POS_FACEUP_DEFENCE,0,POS_FACEUP_ATTACK,0)==0 then return end
	    local g=Duel.SelectMatchingCard(tp,nil,tp,0,LOCATION_MZONE,1,1,nil)
		if g:GetCount()>0 then
		Duel.ChangePosition(g,POS_FACEUP_DEFENCE,POS_FACEUP_ATTACK,POS_FACEUP_ATTACK,POS_FACEUP_ATTACK)
	end
     else	
	 if not tc:IsRelateToEffect(e) or tc:IsFacedown() then return end
	 if Duel.SendtoHand(tc,nil,REASON_EFFECT)>0 and Duel.GetLocationCount(tp,LOCATION_MZONE)>0 then
		Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_SPSUMMON)
			local g=Duel.SelectMatchingCard(tp,c999989018.filter3,tp,LOCATION_HAND,0,1,1,nil,e,tp)
			Duel.SpecialSummon(g,0,tp,tp,false,false,POS_FACEUP)
			Duel.ChangePosition(g,POS_FACEUP_DEFENCE,0,POS_FACEUP_ATTACK,0)
		end
end
end