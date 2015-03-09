--战场女武神 艾利西亚 瓦尔基里
function c11113016.initial_effect(c)
	c:EnableReviveLimit()
	--cannot special summon
	local e1=Effect.CreateEffect(c)
	e1:SetType(EFFECT_TYPE_SINGLE)
	e1:SetProperty(EFFECT_FLAG_CANNOT_DISABLE+EFFECT_FLAG_UNCOPYABLE)
	e1:SetCode(EFFECT_SPSUMMON_CONDITION)
	c:RegisterEffect(e1)
	--to hand 
	local e2=Effect.CreateEffect(c)
	e2:SetDescription(aux.Stringid(11113016,0))
	e2:SetCategory(CATEGORY_TOHAND)
	e2:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_TRIGGER_O)
	e2:SetCode(EVENT_SPSUMMON_SUCCESS)
	e2:SetCountLimit(1,11113016)
	e2:SetCondition(c11113016.thcon)
	e2:SetCost(c11113016.thcost)
	e2:SetTarget(c11113016.thtg)
	e2:SetOperation(c11113016.thop)
	c:RegisterEffect(e2)
	--damage&to hand
	local e3=Effect.CreateEffect(c)
	e3:SetDescription(aux.Stringid(11113016,1))
	e3:SetCategory(CATEGORY_DAMAGE+CATEGORY_TOHAND)
	e3:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_TRIGGER_O)
	e3:SetCode(EVENT_ATTACK_ANNOUNCE)
	e3:SetProperty(EFFECT_FLAG_CARD_TARGET)
	e3:SetRange(LOCATION_GRAVE)
	e3:SetCountLimit(1,111130160)
	e3:SetCondition(c11113016.dmcon)
	e3:SetCost(c11113016.dmcost)
	e3:SetTarget(c11113016.dmtg)
	e3:SetOperation(c11113016.dmop)
	c:RegisterEffect(e3)
end
function c11113016.mat_filter(c)
	return c:GetLevel()~=9
end
function c11113016.thcon(e,tp,eg,ep,ev,re,r,rp)
	return bit.band(e:GetHandler():GetSummonType(),SUMMON_TYPE_RITUAL)==SUMMON_TYPE_RITUAL
end	
function c11113016.dfilter(c)
    return c:IsFaceup() and c:IsSetCard(0x15c) and c:IsAbleToDeckAsCost()
end
function c11113016.thcost(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.IsExistingMatchingCard(c11113016.dfilter,tp,LOCATION_REMOVED,0,1,nil) end
	local g=Duel.GetMatchingGroup(c11113016.dfilter,tp,LOCATION_REMOVED,0,nil)
	Duel.SendtoDeck(g,nil,2,REASON_COST)
end
function c11113016.thtg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.IsExistingMatchingCard(Card.IsAbleToHand,tp,LOCATION_ONFIELD,LOCATION_ONFIELD,1,e:GetHandler()) end
	local g=Duel.GetMatchingGroup(Card.IsAbleToHand,tp,LOCATION_ONFIELD,LOCATION_ONFIELD,e:GetHandler())
	Duel.SetOperationInfo(0,CATEGORY_TOHAND,g,g:GetCount(),0,0)
end
function c11113016.dcon(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	return ep~=tp and (c==Duel.GetAttacker() or c==Duel.GetAttackTarget())
end
function c11113016.dop(e,tp,eg,ep,ev,re,r,rp)
	Duel.ChangeBattleDamage(ep,ev/2)
end
function c11113016.thop(e,tp,eg,ep,ev,re,r,rp)
    local c=e:GetHandler()
	local g=Duel.GetMatchingGroup(Card.IsAbleToHand,tp,LOCATION_ONFIELD,LOCATION_ONFIELD,e:GetHandler())
	Duel.SendtoHand(g,nil,REASON_EFFECT)
	local e1=Effect.CreateEffect(c)
	e1:SetType(EFFECT_TYPE_CONTINUOUS+EFFECT_TYPE_FIELD)
	e1:SetRange(LOCATION_MZONE)
	e1:SetProperty(EFFECT_FLAG_CANNOT_DISABLE)
	e1:SetCode(EVENT_PRE_BATTLE_DAMAGE)
	e1:SetReset(RESET_EVENT+0x1fe0000+RESET_PHASE+RESET_END)
	e1:SetCondition(c11113016.dcon)
	e1:SetOperation(c11113016.dop)
	c:RegisterEffect(e1)
end
function c11113016.cfilter(c)
    return c:IsSetCard(0x15c) and bit.band(c:GetType(),0x82)==0x82
end	
function c11113016.dmcon(e,tp,eg,ep,ev,re,r,rp)
	local at=Duel.GetAttacker()
	return at:GetControler()~=tp and at:GetAttack()>=2000 and Duel.IsExistingMatchingCard(c11113016.cfilter,tp,LOCATION_GRAVE,0,1,nil)
end
function c11113016.dmcost(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return e:GetHandler():IsAbleToRemoveAsCost() end
	Duel.Remove(e:GetHandler(),POS_FACEUP,REASON_COST)
end
function c11113016.dmtg(e,tp,eg,ep,ev,re,r,rp,chk,chkc)
	local at=Duel.GetAttacker()
	if chkc then return chkc==at end
	if chk==0 then return at:IsOnField() and at:IsAbleToHand() and at:IsCanBeEffectTarget(e) end
	Duel.SetTargetCard(at)
	local dam=at:GetAttack()/2
	Duel.SetOperationInfo(0,CATEGORY_DAMAGE,nil,0,1-tp,dam)
	Duel.SetOperationInfo(0,CATEGORY_TOHAND,at,1,0,0)
end
function c11113016.dmop(e,tp,eg,ep,ev,re,r,rp)
	local tc=Duel.GetFirstTarget()
	if tc:IsRelateToEffect(e) and tc:IsFaceup() then
		if Duel.Damage(1-tp,tc:GetAttack()/2,REASON_EFFECT)~=0 then
		    Duel.BreakEffect()
			Duel.SendtoHand(tc,nil,REASON_EFFECT)
		end
	end
end