--镜现诗·四季的鲜花之主
function c19300037.initial_effect(c)
	--special summon
	local e1=Effect.CreateEffect(c)
	e1:SetType(EFFECT_TYPE_FIELD)
	e1:SetCode(EFFECT_SPSUMMON_PROC)
	e1:SetProperty(EFFECT_FLAG_UNCOPYABLE)
	e1:SetRange(LOCATION_HAND)
	e1:SetCondition(c19300037.spcon)
	e1:SetOperation(c19300037.spop)
	c:RegisterEffect(e1)
	--destroy
	local e2=Effect.CreateEffect(c)
	e2:SetCategory(CATEGORY_DESTROY)
	e2:SetType(EFFECT_TYPE_IGNITION)
	e2:SetProperty(EFFECT_FLAG_CARD_TARGET)
	e2:SetRange(LOCATION_MZONE)
	e2:SetCountLimit(1)
	e2:SetCost(c19300037.thcost)
	e2:SetTarget(c19300037.destg)
	e2:SetOperation(c19300037.desop)
	c:RegisterEffect(e2)
end
function c19300037.spcon(e,c)
	if c==nil then return true end
	return Duel.CheckReleaseGroup(c:GetControler(),Card.IsSetCard,2,nil,0x193)
end
function c19300037.spop(e,tp,eg,ep,ev,re,r,rp,c)
	local g=Duel.SelectReleaseGroup(c:GetControler(),Card.IsSetCard,2,2,nil,0x193)
	Duel.Release(g,REASON_COST)
end
function c19300037.cffilter(c)
	return c:IsSetCard(0x193) and c:GetCode()~=19300037 and not c:IsPublic()
end
function c19300037.thcost(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.IsExistingMatchingCard(c19300037.cffilter,tp,LOCATION_HAND,0,2,nil) end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_CONFIRM)
	local g=Duel.SelectMatchingCard(tp,c19300037.cffilter,tp,LOCATION_HAND,0,2,2,nil)
	Duel.ConfirmCards(1-tp,g)
	Duel.ShuffleHand(tp)
end
function c19300037.filter(c,atk)
	return c:IsFaceup() and c:GetBaseAttack()<atk and c:IsDestructable()
end
function c19300037.destg(e,tp,eg,ep,ev,re,r,rp,chk,chkc)
	local c=e:GetHandler()
	if chkc then return chkc:IsLocation(LOCATION_MZONE) and c19300037.filter(chkc,c:GetBaseAttack()) end
	if chk==0 then return Duel.IsExistingTarget(c19300037.filter,tp,LOCATION_MZONE,LOCATION_MZONE,1,nil,c:GetBaseAttack()) end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_DESTROY)
	local g=Duel.SelectTarget(tp,c19300037.filter,tp,LOCATION_MZONE,LOCATION_MZONE,1,1,nil,c:GetBaseAttack())
	Duel.SetOperationInfo(0,CATEGORY_DESTROY,g,g:GetCount(),0,0)
end
function c19300037.desfilter(c,e,atk)
	return c:IsFaceup() and c:IsRelateToEffect(e) and c:GetBaseAttack()<atk
end
function c19300037.desop(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	if not c:IsRelateToEffect(e) then return end
	local g=Duel.GetChainInfo(0,CHAININFO_TARGET_CARDS)
	local sg=g:Filter(c19300037.desfilter,nil,e,c:GetBaseAttack())
	Duel.Destroy(sg,REASON_EFFECT)
end