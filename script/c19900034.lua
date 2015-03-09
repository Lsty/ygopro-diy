--群青RAIN
function c19900034.initial_effect(c)
	c:EnableCounterPermit(0x3004)
	--Activate
	local e1=Effect.CreateEffect(c)
	e1:SetType(EFFECT_TYPE_ACTIVATE)
	e1:SetCode(EVENT_FREE_CHAIN)
	c:RegisterEffect(e1)
	--Add counter
	local e2=Effect.CreateEffect(c)
	e2:SetType(EFFECT_TYPE_CONTINUOUS+EFFECT_TYPE_FIELD)
	e2:SetCode(EVENT_CHAIN_SOLVING)
	e2:SetProperty(EFFECT_FLAG_DELAY)
	e2:SetRange(LOCATION_SZONE)
	e2:SetCondition(c19900034.ctcon)
	e2:SetOperation(c19900034.ctop)
	c:RegisterEffect(e2)
	--atkup
	local e3=Effect.CreateEffect(c)
	e3:SetType(EFFECT_TYPE_FIELD)
	e3:SetCode(EFFECT_UPDATE_ATTACK)
	e3:SetRange(LOCATION_SZONE)
	e3:SetTargetRange(LOCATION_MZONE,0)
	e3:SetTarget(aux.TargetBoolFunction(Card.IsSetCard,0x199))
	e3:SetValue(c19900034.atkval)
	c:RegisterEffect(e3)
	--search
	local e4=Effect.CreateEffect(c)
	e4:SetCategory(CATEGORY_TOHAND+CATEGORY_SEARCH)
	e4:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_TRIGGER_O)
	e4:SetProperty(EFFECT_FLAG_DAMAGE_STEP+EFFECT_FLAG_DELAY)
	e4:SetCode(EVENT_LEAVE_FIELD)
	e4:SetCondition(c19900034.thcon)
	e4:SetTarget(c19900034.thtg)
	e4:SetOperation(c19900034.thop)
	c:RegisterEffect(e4)
end
function c19900034.ctcon(e,tp,eg,ep,ev,re,r,rp)
	local c=re:GetHandler()
	return e:GetHandler()~=re:GetHandler() and re:IsActiveType(TYPE_MONSTER) and c:IsSetCard(0x199)
end
function c19900034.ctop(e,tp,eg,ep,ev,re,r,rp)
	e:GetHandler():AddCounter(0x3004,1)
end
function c19900034.atkval(e,c)
	return e:GetHandler():GetCounter(0x3004)*100
end
function c19900034.thcon(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	local ct=c:GetCounter(0x3004)
	e:SetLabel(ct)
	return ct>0 and c:IsLocation(LOCATION_GRAVE)
end
function c19900034.filter(c,lv)
	return c:IsLevelBelow(lv) and c:IsSetCard(0x199) and c:IsAbleToHand()
end
function c19900034.filter1(c,lv)
	return c:IsSetCard(0x199) and c:IsAbleToHand()
end
function c19900034.thtg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.IsExistingMatchingCard(c19900034.filter,tp,LOCATION_DECK,0,1,nil,e:GetLabel()) end
	Duel.SetOperationInfo(0,CATEGORY_TOHAND,nil,1,tp,LOCATION_DECK)
end
function c19900034.thop(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	local slv=e:GetLabel()
	local sg=Duel.GetMatchingGroup(c19900034.filter1,tp,LOCATION_DECK,0,nil)
	sg:Remove(Card.IsLevelAbove,nil,slv+1)
	if sg:GetCount()==0 then return end
	repeat
		Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_ATOHAND)
		local tc=sg:Select(tp,1,1,nil):GetFirst()
		sg:RemoveCard(tc)
		slv=slv-tc:GetLevel()
		Duel.SendtoHand(tc,nil,REASON_EFFECT)
		Duel.ConfirmCards(1-tp,tc)
		sg:Remove(Card.IsLevelAbove,nil,slv+1)
	until sg:GetCount()==0 or not Duel.SelectYesNo(tp,aux.Stringid(19900034,0))
end