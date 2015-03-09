--血符·血之魔方阵
function c73300014.initial_effect(c)
	c:SetUniqueOnField(1,0,73300014)
	--Activate
	local e1=Effect.CreateEffect(c)
	e1:SetType(EFFECT_TYPE_ACTIVATE)
	e1:SetCode(EVENT_FREE_CHAIN)
	c:RegisterEffect(e1)
	--recover
	local e2=Effect.CreateEffect(c)
	e2:SetCategory(CATEGORY_RECOVER)
	e2:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_TRIGGER_F)
	e2:SetProperty(EFFECT_FLAG_PLAYER_TARGET)
	e2:SetRange(LOCATION_SZONE)
	e2:SetCode(EVENT_DAMAGE)
	e2:SetCountLimit(1)
	e2:SetCondition(c73300014.reccon)
	e2:SetTarget(c73300014.rectg)
	e2:SetOperation(c73300014.recop)
	c:RegisterEffect(e2)
	--atk up
	local e3=Effect.CreateEffect(c)
	e3:SetType(EFFECT_TYPE_FIELD)
	e3:SetRange(LOCATION_SZONE)
	e3:SetTargetRange(LOCATION_MZONE,0)
	e3:SetCode(EFFECT_UPDATE_ATTACK)
	e3:SetTarget(c73300014.target)
	e3:SetValue(c73300014.atkval)
	c:RegisterEffect(e3)
end
function c73300014.reccon(e,tp,eg,ep,ev,re,r,rp)
	if ep==tp or r~=REASON_BATTLE then return false end
	local rc=eg:GetFirst()
	return rc:IsControler(tp) and rc:IsSetCard(0x733)
end
function c73300014.rectg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return true end
	Duel.SetTargetPlayer(tp)
	Duel.SetTargetParam(ev)
	Duel.SetOperationInfo(0,CATEGORY_RECOVER,nil,0,tp,ev)
end
function c73300014.recop(e,tp,eg,ep,ev,re,r,rp)
	if not e:GetHandler():IsRelateToEffect(e) then return end
	local p,d=Duel.GetChainInfo(0,CHAININFO_TARGET_PLAYER,CHAININFO_TARGET_PARAM)
	Duel.Recover(p,d,REASON_EFFECT)
end
function c73300014.target(e,c)
	return c:IsFaceup() and c:IsSetCard(0x733)
end
function c73300014.atkval(e,c)
	local cont=c:GetControler()
	local p1=Duel.GetLP(cont)
	local p2=Duel.GetLP(1-cont)
	local s=p2-p1
	if s<0 then s=p1-p2 end
	local d=math.floor(s/1000)
	return d*200
end