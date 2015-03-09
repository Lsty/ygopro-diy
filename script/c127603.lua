--棋策师的战场
function c127603.initial_effect(c)
	--Activate
	local e1=Effect.CreateEffect(c)
	e1:SetType(EFFECT_TYPE_ACTIVATE)
	e1:SetCode(EVENT_FREE_CHAIN)
	c:RegisterEffect(e1)
	--counter
	local e2=Effect.CreateEffect(c)
	e2:SetCategory(CATEGORY_COUNTER)
	e2:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_TRIGGER_O)
	e2:SetCode(EVENT_SUMMON_SUCCESS)
	e2:SetProperty(EFFECT_FLAG_DAMAGE_STEP+EFFECT_FLAG_DELAY+EFFECT_FLAG_CARD_TARGET)
	e2:SetRange(LOCATION_SZONE)
	e2:SetTarget(c127603.target)
	e2:SetCondition(c127603.ctcon)
	e2:SetOperation(c127603.ctop)
	c:RegisterEffect(e2)
	local e3=e2:Clone()
	e3:SetCode(EVENT_SPSUMMON_SUCCESS)
	c:RegisterEffect(e3)
	local e4=e2:Clone()
	e4:SetCode(EVENT_FLIP_SUMMON_SUCCESS)
	c:RegisterEffect(e4)
	--atk def
	local e5=Effect.CreateEffect(c)
	e5:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_TRIGGER_O)
	e5:SetCode(EVENT_BATTLE_START)
	e5:SetCategory(CATEGORY_DESTROY)
	e5:SetRange(LOCATION_SZONE)
	e5:SetCondition(c127603.adcon)
	e5:SetOperation(c127603.adval)
	c:RegisterEffect(e5)
end
function c127603.cfilter(c)
	return c:IsSetCard(0x7fb) and c:IsType(TYPE_MONSTER) 
end
function c127603.ctcon(e,tp,eg,ep,ev,re,r,rp)
	return eg:IsExists(c127603.cfilter,1,nil)
end
function c127603.target(e,tp,eg,ep,ev,re,r,rp,chk,chkc)
	if chkc then return chkc:IsLocation(LOCATION_MZONE) and chkc:IsControler(1-tp) and chkc:IsFaceup() end
	if chk==0 then return Duel.IsExistingTarget(Card.IsFaceup,tp,0,LOCATION_MZONE,1,nil) end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_FACEUP)
	local g=Duel.SelectTarget(tp,Card.IsFaceup,tp,0,LOCATION_MZONE,1,1,nil)
	Duel.SetOperationInfo(0,CATEGORY_COUNTER,g,1,0x16,1)
end
function c127603.ctop(e,tp,eg,ep,ev,re,r,rp)
	local tc=Duel.GetFirstTarget()
	if tc:IsFaceup() and tc:IsRelateToEffect(e) then
		tc:AddCounter(0x16,1)
	end
end
function c127603.adcon(e,tp,eg,ep,ev,re,r,rp)
	local a=Duel.GetAttacker() local d=Duel.GetAttackTarget()
	if not d then return false end
	local g=Group.CreateGroup()
	if a:GetCounter(0x16)~=0 and d:IsSetCard(0x7fb) and d:IsControler(tp) then g:AddCard(a) end
	if d:GetCounter(0x16)~=0 and a:IsSetCard(0x7fb) and a:IsControler(tp) then g:AddCard(d) end
	return g:GetCount()~=0
end
function c127603.adval(e,tp,eg,ep,ev,re,r,rp)
	local a=Duel.GetAttacker() local d=Duel.GetAttackTarget()
	local g=Group.CreateGroup()
	if a:GetCounter(0x16)~=0 and d:IsSetCard(0x7fb) and d:IsControler(tp) and a:IsRelateToBattle() then g:AddCard(a) end
	if d:GetCounter(0x16)~=0 and a:IsSetCard(0x7fb) and a:IsControler(tp) and d:IsRelateToBattle() then g:AddCard(d) end
	if g:GetCount()~=0 then Duel.Destroy(g,REASON_EFFECT) end
end
