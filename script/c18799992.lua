--魔人小司
function c18799992.initial_effect(c)
	--synchro summon
	aux.AddSynchroProcedure(c,aux.FilterBoolFunction(c18799992.synfilter),aux.NonTuner(c18799992.scyfilter2),1)
	c:EnableReviveLimit()
	--change name
	local e2=Effect.CreateEffect(c)
	e2:SetType(EFFECT_TYPE_SINGLE)
	e2:SetProperty(EFFECT_FLAG_SINGLE_RANGE)
	e2:SetCode(EFFECT_CHANGE_CODE)
	e2:SetRange(LOCATION_ONFIELD)
	e2:SetValue(18799991)
	c:RegisterEffect(e2)
	--search
	local e1=Effect.CreateEffect(c)
	e1:SetCategory(CATEGORY_TOHAND+CATEGORY_SEARCH)
	e1:SetType(EFFECT_TYPE_TRIGGER_O+EFFECT_TYPE_SINGLE)
	e1:SetCode(EVENT_SPSUMMON_SUCCESS)
	e1:SetCondition(c18799992.secon)
	e1:SetTarget(c18799992.tg)
	e1:SetOperation(c18799992.op)
	c:RegisterEffect(e1)
	--recycle
	local e5=Effect.CreateEffect(c)
	e5:SetCategory(CATEGORY_LEAVE_GRAVE+CATEGORY_TOHAND)
	e5:SetProperty(EFFECT_FLAG_CARD_TARGET)
	e5:SetType(EFFECT_TYPE_IGNITION)
	e5:SetCountLimit(1,18799992)
	e5:SetRange(LOCATION_MZONE)
	e5:SetTarget(c18799992.retg)
	e5:SetOperation(c18799992.reop)
	c:RegisterEffect(e5)
	local e3=Effect.CreateEffect(c)
	e3:SetType(EFFECT_TYPE_SINGLE)
	e3:SetProperty(EFFECT_FLAG_SINGLE_RANGE)
	e3:SetRange(LOCATION_MZONE)
	e3:SetCode(EFFECT_INDESTRUCTABLE_EFFECT)
	e3:SetValue(c18799992.efilter)
	c:RegisterEffect(e3)
	local e2=Effect.CreateEffect(c)
	e2:SetType(EFFECT_TYPE_SINGLE)
	e2:SetCode(EFFECT_INDESTRUCTABLE_BATTLE)
	e2:SetValue(c18799992.ind2)
	c:RegisterEffect(e2)
end
function c18799992.synfilter(c)
	return  c:IsSetCard(0x984) or c:IsSetCard(0x985)
end
function c18799992.secon(e,tp,eg,ep,ev,re,r,rp)
    return e:GetHandler():GetSummonType()==SUMMON_TYPE_SYNCHRO
end
function c18799992.scyfilter2(c)
	return c:IsSetCard(0x3e1)
end
function c18799992.tg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.IsExistingMatchingCard(c18799992.filter,tp,LOCATION_DECK+LOCATION_GRAVE,0,1,nil) and
	Duel.IsExistingMatchingCard(c18799992.filter2,tp,LOCATION_DECK+LOCATION_GRAVE,0,1,nil)  end
	Duel.SetOperationInfo(0,CATEGORY_TOHAND,nil,1,tp,LOCATION_DECK+LOCATION_GRAVE)
end
function c18799992.op(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	local g1=Duel.SelectMatchingCard(tp,c18799992.filter,tp,LOCATION_DECK+LOCATION_GRAVE,0,1,1,nil)
	local tc1=g1:GetFirst()
	if tc1 then
		if Duel.GetLocationCount(tp,LOCATION_SZONE)>0 
			and (not tc1:IsAbleToHand() or Duel.SelectYesNo(tp,aux.Stringid(18799992,0))) then
			if c:IsFacedown() or not c:IsRelateToEffect(e) then return end
			Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_EQUIP)
			Duel.Equip(tp,tc1,c)
		else
		 Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_ATOHAND)
			Duel.SendtoHand(tc1,nil,REASON_EFFECT)
			Duel.ConfirmCards(1-tp,tc1)
		end
end
    local g2=Duel.SelectMatchingCard(tp,c18799992.filter2,tp,LOCATION_DECK+LOCATION_GRAVE,0,1,1,nil)
	local tc2=g2:GetFirst()
	if tc2 then
		if Duel.GetLocationCount(tp,LOCATION_SZONE)>0  then
			if c:IsFacedown() or not c:IsRelateToEffect(e) then return end
		 Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_ATOHAND)
			Duel.SendtoHand(tc2,nil,REASON_EFFECT)
			Duel.ConfirmCards(1-tp,tc2)
		end
end
end
function c18799992.filter(c)
	local code=c:GetCode()
	return (code==18799993) 
end
function c18799992.filter2(c)
	local code=c:GetCode()
	return (code==18799994) 
end
function c18799992.thfilter(c)
	return c:IsFaceup() and c:IsCanTurnSet() and not c:IsStatus(STATUS_LEAVE_CONFIRMED) and c:GetSequence()~=6 and c:GetSequence()~=7
end
function c18799992.retg(e,tp,eg,ep,ev,re,r,rp,chk,chkc)
	if chkc then return chkc:IsLocation(LOCATION_ONFIELD) and c18799992.thfilter(chkc) end
	if chk==0 then return Duel.IsExistingTarget(c18799992.thfilter,tp,LOCATION_ONFIELD,LOCATION_ONFIELD,1,nil) end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_FACEUP)
	local g=Duel.SelectTarget(tp,c18799992.thfilter,tp,LOCATION_ONFIELD,LOCATION_ONFIELD,1,1,nil)
	Duel.SetOperationInfo(0,CATEGORY_POSITION,g,1,0,0)
end
function c18799992.reop(e,tp,eg,ep,ev,re,r,rp)
	local tc=Duel.GetFirstTarget()
	if tc:IsRelateToEffect(e) and tc:IsFaceup() then
		if tc:IsType(TYPE_MONSTER) then
			Duel.ChangePosition(tc,POS_FACEDOWN_ATTACK,0,POS_FACEDOWN_DEFENCE,0)
		else
			Duel.ChangePosition(tc,POS_FACEDOWN)
			Duel.RaiseEvent(tc,EVENT_SSET,e,REASON_EFFECT,tp,tp,0)
		end
	end
end
function c18799992.ind2(e,c)
	return c:GetRace()==RACE_WARRIOR or c:GetRace()==RACE_SPELLCASTER or c:GetRace()==RACE_ZOMBIE or c:GetRace()==RACE_MACHINE
	or c:GetRace()==RACE_AQUA or c:GetRace()==RACE_PYRO or c:GetRace()==RACE_ROCK or c:GetRace()==RACE_WINDBEAST
	or c:GetRace()==RACE_PLANT or c:GetRace()==RACE_INSECT or c:GetRace()==RACE_THUNDER or c:GetRace()==RACE_DRAGON
	  or c:GetRace()==RACE_BEAST or c:GetRace()==RACE_BEASTWARRIOR or c:GetRace()==RACE_DINOSAUR or c:GetRace()==RACE_FISH
	  or c:GetRace()==RACE_SEASERPENT  or c:GetRace()==RACE_REPTILE  or c:GetRace()==RACE_PSYCHO  or c:GetRace()==RACE_DEVINE
	  or c:GetRace()==RACE_CREATORGOD  or c:GetRace()==RACE_WYRM
end
function c18799992.efilter(e,re)
	return re:IsActiveType(TYPE_SPELL+TYPE_TRAP) or (re:GetHandler():GetRace()==RACE_WARRIOR or re:GetHandler():GetRace()==RACE_SPELLCASTER or re:GetHandler():GetRace()==RACE_ZOMBIE or re:GetHandler():GetRace()==RACE_MACHINE
	or re:GetHandler():GetRace()==RACE_AQUA or re:GetHandler():GetRace()==RACE_PYRO or re:GetHandler():GetRace()==RACE_ROCK or re:GetHandler():GetRace()==RACE_WINDBEAST
	or re:GetHandler():GetRace()==RACE_PLANT or re:GetHandler():GetRace()==RACE_INSECT or re:GetHandler():GetRace()==RACE_THUNDER or re:GetHandler():GetRace()==RACE_DRAGON
	  or re:GetHandler():GetRace()==RACE_BEAST or re:GetHandler():GetRace()==RACE_BEASTWARRIOR or re:GetHandler():GetRace()==RACE_DINOSAUR or re:GetHandler():GetRace()==RACE_FISH
	  or re:GetHandler():GetRace()==RACE_SEASERPENT  or re:GetHandler():GetRace()==RACE_REPTILE  or re:GetHandler():GetRace()==RACE_PSYCHO  or re:GetHandler():GetRace()==RACE_DEVINE
	  or re:GetHandler():GetRace()==RACE_CREATORGOD  or re:GetHandler():GetRace()==RACE_WYRM)
end