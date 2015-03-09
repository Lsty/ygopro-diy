--战场女武神 觉醒极限
function c11113015.initial_effect(c)
    --Activate
	local e1=Effect.CreateEffect(c)
	e1:SetCategory(CATEGORY_SPECIAL_SUMMON)
	e1:SetType(EFFECT_TYPE_ACTIVATE)
	e1:SetCode(EVENT_FREE_CHAIN)
	e1:SetCountLimit(1,11113015)
	e1:SetCondition(c11113015.condition)
	e1:SetTarget(c11113015.target)
	e1:SetOperation(c11113015.activate)
	c:RegisterEffect(e1)
	--Salvage
	local e2=Effect.CreateEffect(c)
	e2:SetDescription(aux.Stringid(11113015,0))
	e2:SetCategory(CATEGORY_TOHAND)
	e2:SetProperty(EFFECT_FLAG_CARD_TARGET)
	e2:SetType(EFFECT_TYPE_IGNITION)
	e2:SetRange(LOCATION_GRAVE)
	e2:SetCountLimit(1,11113015)
	e2:SetCost(c11113015.thcost)
	e2:SetTarget(c11113015.thtg)
	e2:SetOperation(c11113015.thop)
	c:RegisterEffect(e2)
end
function c11113015.condition(e,tp,eg,ep,ev,re,r,rp)
	return Duel.GetFieldGroupCount(tp,LOCATION_MZONE,0)==0
end
function c11113015.filter(c,e,tp,m)
	if bit.band(c:GetType(),0x81)~=0x81 or not c:IsSetCard(0x15c) or (c:IsLocation(LOCATION_REMOVED) and not c:IsFaceup())
	    or not c:IsCanBeSpecialSummoned(e,SUMMON_TYPE_RITUAL,tp,true,true) then return false end
	if c.mat_filter then
		m=m:Filter(c.mat_filter,nil)
	end
    return m:CheckWithSumEqual(Card.GetRitualLevel,c:GetLevel(),1,99,c) 
end
function c11113015.matfilter(c)
	return c:IsSetCard(0x15c) and c:IsType(TYPE_MONSTER) and c:IsAbleToRemove()
end	
function c11113015.target(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then
		if Duel.GetLocationCount(tp,LOCATION_MZONE)<=0 then return false end
		local mg=Duel.GetMatchingGroup(c11113015.matfilter,tp,LOCATION_HAND+LOCATION_GRAVE,0,nil)
		return Duel.IsExistingMatchingCard(c11113015.filter,tp,LOCATION_HAND+LOCATION_REMOVED,0,1,nil,e,tp,mg)
	end
	Duel.SetOperationInfo(0,CATEGORY_SPECIAL_SUMMON,nil,1,tp,LOCATION_HAND+LOCATION_REMOVED)
end
function c11113015.activate(e,tp,eg,ep,ev,re,r,rp)
	if Duel.GetLocationCount(tp,LOCATION_MZONE)<=0 then return end
	local mg=Duel.GetMatchingGroup(c11113015.matfilter,tp,LOCATION_HAND+LOCATION_GRAVE,0,nil)
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_SPSUMMON)
	local tg=Duel.SelectMatchingCard(tp,c11113015.filter,tp,LOCATION_HAND+LOCATION_REMOVED,0,1,1,nil,e,tp,mg)
	if tg:GetCount()>0 then
		local tc=tg:GetFirst()
		if tc.mat_filter then
			mg=mg:Filter(tc.mat_filter,nil)
		end
		Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_REMOVE)
		local mat=mg:SelectWithSumEqual(tp,Card.GetRitualLevel,tc:GetLevel(),1,99,tc)
		tc:SetMaterial(mat)
		Duel.Remove(mat,POS_FACEUP,REASON_EFFECT+REASON_MATERIAL+REASON_RITUAL)
		Duel.BreakEffect()
		Duel.SpecialSummon(tc,SUMMON_TYPE_RITUAL,tp,tp,true,true,POS_FACEUP)
		tc:CompleteProcedure()
	end
end
function c11113015.thcost(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return e:GetHandler():IsAbleToRemoveAsCost() end
	Duel.Remove(e:GetHandler(),POS_FACEUP,REASON_COST)
end
function c11113015.thfilter(c)
	return c:IsSetCard(0x15c) and bit.band(c:GetType(),0x81)==0x81 and c:IsAbleToHand()
end
function c11113015.thtg(e,tp,eg,ep,ev,re,r,rp,chk,chkc)
	if chkc then return chkc:IsLocation(LOCATION_REMOVED) and chkc:IsControler(tp) and c11113015.thfilter(chkc) end
	if chk==0 then return Duel.IsExistingTarget(c11113015.thfilter,tp,LOCATION_REMOVED,0,1,nil) end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_ATOHAND)
	local g=Duel.SelectTarget(tp,c11113015.thfilter,tp,LOCATION_REMOVED,0,1,1,nil)
	Duel.SetOperationInfo(0,CATEGORY_TOHAND,g,1,0,0)
end
function c11113015.thop(e,tp,eg,ep,ev,re,r,rp)
	local tc=Duel.GetFirstTarget()
	if tc and tc:IsRelateToEffect(e) then
		Duel.SendtoHand(tc,nil,REASON_EFFECT)
		Duel.ConfirmCards(1-tp,tc)
	end
end