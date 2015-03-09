--月世界 两仪式
function c1277501.initial_effect(c)
	c:SetUniqueOnField(1,0,1277501)
	c:EnableReviveLimit()
	--remove
	local e1=Effect.CreateEffect(c)
	e1:SetDescription(aux.Stringid(1277501,0))
	e1:SetCategory(CATEGORY_REMOVE)
	e1:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_TRIGGER_F)
	e1:SetCode(EVENT_BATTLE_START)
	e1:SetProperty(EFFECT_FLAG_CANNOT_DISABLE)
	e1:SetTarget(c1277501.destg)
	e1:SetOperation(c1277501.desop)
	c:RegisterEffect(e1)
end
function c1277501.destg(e,tp,eg,ep,ev,re,r,rp,chk)
	local c=e:GetHandler()
	local tc=Duel.GetAttacker()
	if tc==c then tc=Duel.GetAttackTarget() end
	if chk==0 then return tc and tc:IsFaceup() end
	Duel.SetOperationInfo(0,CATEGORY_DESTROY,tc,1,0,0)
end
function c1277501.desop(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	local tc=Duel.GetAttacker()
	if tc==c then tc=Duel.GetAttackTarget() end
	if tc:IsRelateToBattle() then Duel.Remove(tc,nil,REASON_EFFECT) end
	local dg=nil
	local tpe=tc:GetType()
	if bit.band(tpe,TYPE_TOKEN)~=0 then return end
	if bit.band(tpe,0x802040)~=0 then
		dg=Duel.GetMatchingGroup(Card.IsCode,tc:GetControler(),LOCATION_EXTRA,0,nil,tc:GetCode())
	else
		dg=Duel.GetMatchingGroup(Card.IsCode,tc:GetControler(),LOCATION_DECK+LOCATION_HAND,0,nil,tc:GetCode())
	end
	Duel.Remove(dg,POS_FACEUP,REASON_EFFECT)
end

