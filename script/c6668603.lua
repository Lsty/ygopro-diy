--幼小的剑士 比那名居天子
function c6668603.initial_effect(c)
	--search
	local e1=Effect.CreateEffect(c)
	e1:SetCategory(CATEGORY_TOHAND+CATEGORY_SEARCH)
	e1:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_TRIGGER_O)
	e1:SetProperty(EFFECT_FLAG_DAMAGE_STEP+EFFECT_FLAG_DELAY)
	e1:SetCountLimit(1,6668603)
	e1:SetCode(EVENT_TO_GRAVE)
	e1:SetTarget(c6668603.thtg2)
	e1:SetOperation(c6668603.tgop2)
	c:RegisterEffect(e1)
	--atk
	local e2=Effect.CreateEffect(c)
	e2:SetType(EFFECT_TYPE_FIELD)
	e2:SetRange(LOCATION_MZONE)
	e2:SetTargetRange(0,LOCATION_MZONE)
	e2:SetCode(EFFECT_UPDATE_ATTACK)
	e2:SetTarget(c6668603.tg)
	e2:SetValue(500)
	c:RegisterEffect(e2)
	--atk
	local e3=Effect.CreateEffect(c)
	e3:SetType(EFFECT_TYPE_FIELD)
	e3:SetRange(LOCATION_MZONE)
	e3:SetTargetRange(0,LOCATION_MZONE)
	e3:SetCode(EFFECT_DISABLE)
	e3:SetCondition(c6668603.con)
	e3:SetTarget(c6668603.tg)
	c:RegisterEffect(e3)
	local e4=e3:Clone()
	e4:SetCode(EFFECT_DISABLE_EFFECT)
	c:RegisterEffect(e4)
    --ind
	local e99=Effect.CreateEffect(c)
	e99:SetType(EFFECT_TYPE_SINGLE)
	e99:SetProperty(EFFECT_FLAG_SINGLE_RANGE)
	e99:SetRange(LOCATION_MZONE)
	e99:SetCode(EFFECT_INDESTRUCTABLE_BATTLE)
	e99:SetCondition(c6668603.indcon)
	e99:SetValue(1)
	c:RegisterEffect(e99)
end
function c6668603.indcon(e)
	return e:GetHandler():IsPosition(POS_FACEUP_ATTACK)
end	
function c6668603.thfilter2(c)
	return c:IsSetCard(0x740) and c:IsType(TYPE_MONSTER) and not c:IsCode(6668603) and c:IsAbleToHand()
end
function c6668603.thtg2(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.IsExistingMatchingCard(c6668603.thfilter2,tp,LOCATION_DECK,0,1,nil) end
	Duel.SetOperationInfo(0,CATEGORY_TOHAND,nil,1,tp,LOCATION_DECK)
end
function c6668603.tgop2(e,tp,eg,ep,ev,re,r,rp)
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_ATOHAND)
	local g=Duel.SelectMatchingCard(tp,c6668603.thfilter2,tp,LOCATION_DECK,0,1,1,nil)
	if g:GetCount()>0 then
		Duel.SendtoHand(g,nil,REASON_EFFECT)
		Duel.ConfirmCards(1-tp,g)
	end
end
function c6668603.tg(e,c)
	return c:GetBaseAttack()<=2500
end
function c6668603.con(e,tp,eg,ep,ev,re,r,rp)
	return Duel.GetCurrentPhase()==PHASE_BATTLE
end