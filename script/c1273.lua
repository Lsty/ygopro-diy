--N领域 人偶之城
function c1273.initial_effect(c)
	local e1=Effect.CreateEffect(c)
	e1:SetType(EFFECT_TYPE_ACTIVATE)
	e1:SetCode(EVENT_FREE_CHAIN)
	e1:SetCountLimit(1,1273+EFFECT_COUNT_CODE_OATH)
	e1:SetOperation(c1273.activate)
	c:RegisterEffect(e1)
	--search
	local e2=Effect.CreateEffect(c)
	e2:SetCategory(CATEGORY_TOHAND)
	e2:SetType(EFFECT_TYPE_IGNITION)
	e2:SetRange(LOCATION_GRAVE)
	e2:SetCost(c1273.atcost)
	e2:SetTarget(c1273.thtg)
	e2:SetOperation(c1273.thop)
	c:RegisterEffect(e2)
	--atk up
	local e3=Effect.CreateEffect(c)
	e3:SetType(EFFECT_TYPE_FIELD)
	e3:SetRange(LOCATION_SZONE)
	e3:SetCode(EFFECT_UPDATE_ATTACK)
	e3:SetTargetRange(LOCATION_MZONE,0)
	e3:SetTarget(aux.TargetBoolFunction(Card.IsSetCard,0x21a))
	e3:SetValue(300)
	c:RegisterEffect(e3)
end
function c1273.activate(e,tp,eg,ep,ev,re,r,rp,chk)
	if not e:GetHandler():IsRelateToEffect(e) then return end
	if Duel.GetLocationCount(tp,LOCATION_MZONE)<=0 then return end
	if Duel.IsPlayerCanSpecialSummonMonster(tp,1270,0x21a,0x4011,0,0,4,RACE_MACHINE,ATTRIBUTE_DARK) 
	and Duel.GetActivityCount(tp,ACTIVITY_SUMMON)==0 then
		if Duel.SelectYesNo(tp,aux.Stringid(1273,0)) then
			local token=Duel.CreateToken(tp,1270)
			Duel.SpecialSummon(token,0,tp,tp,false,false,POS_FACEUP)
			local e2=Effect.CreateEffect(e:GetHandler())
			e2:SetType(EFFECT_TYPE_FIELD)
			e2:SetProperty(EFFECT_FLAG_PLAYER_TARGET+EFFECT_FLAG_OATH)
			e2:SetCode(EFFECT_CANNOT_SUMMON)
			e2:SetReset(RESET_PHASE+PHASE_END)
			e2:SetTargetRange(1,0)
			Duel.RegisterEffect(e2,tp)	
		end
	end
end
function c1273.atfilter(c)
	return c:IsFaceup() and c:IsSetCard(0x21f) and c:IsAbleToGraveAsCost()
end
function c1273.atcost(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.IsExistingMatchingCard(c1273.atfilter,tp,LOCATION_ONFIELD,0,1,nil) end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_TOGRAVE)
	local g=Duel.SelectMatchingCard(tp,c1273.atfilter,tp,LOCATION_ONFIELD,0,1,1,nil)
	Duel.SendtoGrave(g,REASON_COST)
end
function c1273.thtg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return e:GetHandler():IsAbleToHand() end
	Duel.SetOperationInfo(0,CATEGORY_TOHAND,e:GetHandler(),1,0,0)
end
function c1273.thop(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	if c:IsRelateToEffect(e) then
		Duel.SendtoHand(c,nil,REASON_EFFECT)
		Duel.ConfirmCards(1-tp,c)
	end
end
