--百合百合 叛逆转校生 川村玲绪
function c2222295.initial_effect(c)
	--pendulum summon
	aux.AddPendulumProcedure(c)
	--Activate
	local e1=Effect.CreateEffect(c)
	e1:SetType(EFFECT_TYPE_ACTIVATE)
	e1:SetCode(EVENT_FREE_CHAIN)
	c:RegisterEffect(e1)
	--recover
	local e2=Effect.CreateEffect(c)
	e2:SetCode(EVENT_SPSUMMON_SUCCESS)
	e2:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_TRIGGER_F)
	e2:SetProperty(EFFECT_FLAG_PLAYER_TARGET)
	e2:SetCategory(CATEGORY_RECOVER)
	e2:SetDescription(aux.Stringid(2222295,0))
	e2:SetRange(LOCATION_PZONE)
	e2:SetCountLimit(1)
	e2:SetTarget(c2222295.target)
	e2:SetOperation(c2222295.operation)
	c:RegisterEffect(e2)
	--discard card
	local e3=Effect.CreateEffect(c)
	e3:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_TRIGGER_F)
	e3:SetCategory(CATEGORY_DESTROY)
	e3:SetDescription(aux.Stringid(2222295,1))
	e3:SetCountLimit(1)
	e3:SetCode(EVENT_PHASE+PHASE_END)
	e3:SetCondition(c2222295.indcon)
	e3:SetRange(LOCATION_MZONE)
	e3:SetTarget(c2222295.target2)
	e3:SetOperation(c2222295.operation2)
	c:RegisterEffect(e3)
	--destroy
	local e4=Effect.CreateEffect(c)
	e4:SetDescription(aux.Stringid(2222295,2))
	e4:SetCategory(CATEGORY_DESTROY)
	e4:SetType(EFFECT_TYPE_QUICK_O)
	e4:SetProperty(EFFECT_FLAG_CARD_TARGET)
	e4:SetCode(EVENT_FREE_CHAIN)
	e4:SetRange(LOCATION_MZONE)
	e4:SetCountLimit(1,2222295)
	e4:SetTarget(c2222295.target3)
	e4:SetOperation(c2222295.activate)
	c:RegisterEffect(e4)
    --disable spsummon
	local e7=Effect.CreateEffect(c)
	e7:SetType(EFFECT_TYPE_FIELD)
	e7:SetRange(LOCATION_PZONE)
	e7:SetCode(EFFECT_CANNOT_SPECIAL_SUMMON)
	e7:SetProperty(EFFECT_FLAG_PLAYER_TARGET)
	e7:SetTargetRange(1,0)
	e7:SetTarget(c2222295.splimit)
	c:RegisterEffect(e7)
end
function c2222295.filter3(c,tp)
	return c:IsSetCard(0xa74) and c:IsControler(tp) and c:GetSummonType()==SUMMON_TYPE_PENDULUM
end
function c2222295.condition(e,tp,eg,ep,ev,re,r,rp)
	return eg:IsExists(c2222295.filter3,1,nil,tp)
end
function c2222295.target(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.IsExistingMatchingCard(c2222295.filter,tp,LOCATION_MZONE,0,1,nil) end
	Duel.SetTargetPlayer(tp)
	local rec=Duel.GetMatchingGroupCount(c2222295.filter,tp,LOCATION_MZONE,0,nil)*400
	Duel.SetTargetParam(rec)
	Duel.SetOperationInfo(0,CATEGORY_RECOVER,nil,0,tp,rec)
end
function c2222295.filter(c)
	return c:IsFaceup() and c:IsSetCard(0xa74)
end
function c2222295.operation(e,tp,eg,ep,ev,re,r,rp)
    if not e:GetHandler():IsRelateToEffect(e) then return end
	local rec=Duel.GetMatchingGroupCount(c2222295.filter,tp,LOCATION_MZONE,0,nil)*400
	local p=Duel.GetChainInfo(0,CHAININFO_TARGET_PLAYER)
	Duel.Recover(p,rec,REASON_EFFECT)
end
function c2222295.target2(e,tp,eg,ep,ev,re,r,rp,chk,chkc)
	if chkc then return chkc:IsOnField() and chkc:IsDestructable() and chkc~=e:GetHandler() end
	if chk==0 then return Duel.IsExistingTarget(Card.IsDestructable,tp,LOCATION_ONFIELD,0,1,e:GetHandler()) end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_DESTROY)
	local g=Duel.SelectTarget(tp,Card.IsDestructable,tp,LOCATION_ONFIELD,0,1,1,e:GetHandler())
	Duel.SetOperationInfo(0,CATEGORY_DESTROY,g,1,0,0)
end
function c2222295.operation2(e,tp,eg,ep,ev,re,r,rp)
	local tc=Duel.GetFirstTarget()
	if tc:IsRelateToEffect(e) then
		Duel.Destroy(tc,REASON_EFFECT)
	end
end
function c2222295.filter2(c)
	return c:IsDestructable()
end
function c2222295.target3(e,tp,eg,ep,ev,re,r,rp,chk,chkc)
	if chkc then return chkc:IsOnField() and c2222295.filter(chkc) end
	if chk==0 then return Duel.IsExistingTarget(c2222295.filter2,tp,0,LOCATION_MZONE,1,nil) end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_DESTROY)
	local g=Duel.SelectTarget(tp,c2222295.filter2,tp,0,LOCATION_MZONE,1,1,nil)
	Duel.SetOperationInfo(0,CATEGORY_DESTROY,g,1,0,0)
end
function c2222295.activate(e,tp,eg,ep,ev,re,r,rp)
	local tc=Duel.GetFirstTarget()
	if tc and tc:IsRelateToEffect(e) then
		Duel.Destroy(tc,REASON_EFFECT)
	end
end
function c2222295.filter4(c)
	return c:IsFaceup() and c:IsCode(2222294)
end
function c2222295.indcon(e,tp,c)
	return tp==Duel.GetTurnPlayer() and not Duel.IsExistingMatchingCard(c2222295.filter4,e:GetHandler():GetControler(),LOCATION_MZONE,0,1,nil)
end
function c2222295.splimit(e,c,tp,sumtp,sumpos)
	return bit.band(sumtp,SUMMON_TYPE_SYNCHRO)==SUMMON_TYPE_SYNCHRO or bit.band(sumtp,SUMMON_TYPE_XYZ)==SUMMON_TYPE_XYZ
end