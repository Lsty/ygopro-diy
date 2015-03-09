--战场女武神 艾莉娅丝 瓦尔基里
function c11113002.initial_effect(c)
	c:EnableReviveLimit()
	--cannot special summon
	local e1=Effect.CreateEffect(c)
	e1:SetType(EFFECT_TYPE_SINGLE)
	e1:SetProperty(EFFECT_FLAG_CANNOT_DISABLE+EFFECT_FLAG_UNCOPYABLE)
	e1:SetCode(EFFECT_SPSUMMON_CONDITION)
	c:RegisterEffect(e1)
	--send to hand
	local e2=Effect.CreateEffect(c)
	e2:SetDescription(aux.Stringid(11113002,0))
	e2:SetCategory(CATEGORY_TOHAND)
	e2:SetProperty(EFFECT_FLAG_CARD_TARGET)
	e2:SetType(EFFECT_TYPE_IGNITION)
	e2:SetRange(LOCATION_MZONE)
	e2:SetCountLimit(1,11113002)
	e2:SetCost(c11113002.thcost)
	e2:SetTarget(c11113002.thtg)
	e2:SetOperation(c11113002.thop)
	c:RegisterEffect(e2)
	--destroy&damage
	local e3=Effect.CreateEffect(c)
	e3:SetDescription(aux.Stringid(11113002,1))
	e3:SetCategory(CATEGORY_DESTROY+CATEGORY_DAMAGE)
	e3:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_TRIGGER_O)
	e3:SetCode(EVENT_ATTACK_ANNOUNCE)
	e3:SetRange(LOCATION_GRAVE)
	e3:SetCountLimit(1,111130020)
	e3:SetCondition(c11113002.dmcon)
	e3:SetCost(c11113002.dmcost)
	e3:SetTarget(c11113002.dmtg)
	e3:SetOperation(c11113002.dmop)
	c:RegisterEffect(e3)
end
function c11113002.mat_filter(c)
	return c:GetLevel()~=6
end
function c11113002.dfilter(c)
    return c:IsSetCard(0x15c) and c:IsAbleToDeckAsCost()
end	
function c11113002.thcost(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.IsExistingMatchingCard(c11113002.dfilter,tp,LOCATION_REMOVED,0,1,nil) end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_TODECK)
	local g=Duel.SelectMatchingCard(tp,c11113002.dfilter,tp,LOCATION_REMOVED,0,1,1,nil)
	Duel.SendtoDeck(g,nil,2,REASON_COST)
end
function c11113002.thtg(e,tp,eg,ep,ev,re,r,rp,chk,chkc)
	if chkc then return chkc:IsOnField() and chkc:IsControler(1-tp) and chkc:IsAbleToHand() end
	if chk==0 then return Duel.IsExistingMatchingCard(Card.IsAbleToHand,tp,0,LOCATION_ONFIELD,1,nil) end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_RTOHAND)
	local g=Duel.SelectTarget(tp,Card.IsAbleToHand,tp,0,LOCATION_ONFIELD,1,1,nil)
	Duel.SetOperationInfo(0,CATEGORY_TOHAND,g,1,0,0)
end
function c11113002.thop(e,tp,eg,ep,ev,re,r,rp)
	local tc=Duel.GetFirstTarget()
	if tc:IsRelateToEffect(e) then
		Duel.SendtoHand(tc,nil,REASON_EFFECT)
	end
end
function c11113002.cfilter(c)
    return c:IsSetCard(0x15c) and bit.band(c:GetType(),0x82)==0x82
end	
function c11113002.mfilter(c)
    return c:IsPosition(POS_FACEUP_ATTACK)
end		
function c11113002.dmcon(e,tp,eg,ep,ev,re,r,rp)
	local at=Duel.GetAttacker()
	return at:GetControler()~=tp and Duel.IsExistingMatchingCard(c11113002.cfilter,tp,LOCATION_GRAVE,0,1,nil)
	    and Duel.GetMatchingGroupCount(c11113002.mfilter,tp,0,LOCATION_MZONE,nil)-Duel.GetMatchingGroupCount(c11113002.mfilter,tp,LOCATION_MZONE,0,nil)>=2
end
function c11113002.dmcost(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return e:GetHandler():IsAbleToRemoveAsCost() end
	Duel.Remove(e:GetHandler(),POS_FACEUP,REASON_COST)
end
function c11113002.dmfilter(c)
	return c:IsPosition(POS_FACEUP_ATTACK) and c:IsDestructable()
end
function c11113002.dmtg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.IsExistingMatchingCard(c11113002.dmfilter,tp,0,LOCATION_MZONE,1,nil) end
	local sg=Duel.GetMatchingGroup(c11113002.dmfilter,tp,0,LOCATION_MZONE,nil)
	Duel.SetOperationInfo(0,CATEGORY_DESTROY,sg,sg:GetCount(),0,0)
	Duel.SetOperationInfo(0,CATEGORY_DAMAGE,nil,0,1-tp,sg:GetCount()*300)
end
function c11113002.dmop(e,tp,eg,ep,ev,re,r,rp)
	local sg=Duel.GetMatchingGroup(c11113002.dmfilter,tp,0,LOCATION_MZONE,nil)
	local ct=Duel.Destroy(sg,REASON_EFFECT)
	if ct>0 then
        Duel.Damage(1-tp,ct*300,REASON_EFFECT)
	end	
end