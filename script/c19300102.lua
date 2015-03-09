--镜现诗·漆黑的春日妖精
function c19300102.initial_effect(c)
	--synchro summon
	c:EnableReviveLimit()
	local e1=Effect.CreateEffect(c)
	e1:SetType(EFFECT_TYPE_FIELD)
	e1:SetCode(EFFECT_SPSUMMON_PROC)
	e1:SetProperty(EFFECT_FLAG_UNCOPYABLE)
	e1:SetRange(LOCATION_EXTRA)
	e1:SetCondition(c19300102.syncon)
	e1:SetOperation(c19300102.synop)
	e1:SetValue(SUMMON_TYPE_SYNCHRO)
	c:RegisterEffect(e1)
	--battle
	local e2=Effect.CreateEffect(c)
	e2:SetType(EFFECT_TYPE_SINGLE)
	e2:SetCode(EFFECT_AVOID_BATTLE_DAMAGE)
	e2:SetValue(1)
	c:RegisterEffect(e2)
	local e3=Effect.CreateEffect(c)
	e3:SetType(EFFECT_TYPE_SINGLE)
	e3:SetCode(EFFECT_INDESTRUCTABLE_BATTLE)
	e3:SetValue(1)
	c:RegisterEffect(e3)
	--negate
	local e4=Effect.CreateEffect(c)
	e4:SetCategory(CATEGORY_REMOVE)
	e4:SetProperty(EFFECT_FLAG_DAMAGE_STEP+EFFECT_FLAG_DAMAGE_CAL)
	e4:SetType(EFFECT_TYPE_QUICK_F)
	e4:SetRange(LOCATION_MZONE)
	e4:SetCode(EVENT_CHAINING)
	e4:SetCondition(c19300102.discon)
	e4:SetTarget(c19300102.distg)
	e4:SetOperation(c19300102.disop)
	c:RegisterEffect(e4)
	--cannot special summon
	local e5=Effect.CreateEffect(c)
	e5:SetProperty(EFFECT_FLAG_CANNOT_DISABLE+EFFECT_FLAG_UNCOPYABLE)
	e5:SetType(EFFECT_TYPE_SINGLE)
	e5:SetCode(EFFECT_SPSUMMON_CONDITION)
	e5:SetValue(aux.FALSE)
	c:RegisterEffect(e5)
end
function c19300102.matfilter(c,syncard)
	return c:IsFaceup() and c:IsCanBeSynchroMaterial(syncard)
end
function c19300102.synfilter1(c,lv,g)
	local tlv=c:GetLevel()
	if lv-tlv<=0 then return false end
	local t=false
	if c:IsType(TYPE_TUNER) then t=true end
	g:RemoveCard(c)
	local res=g:IsExists(c19300102.synfilter2,1,nil,lv-tlv,g,t)
	g:AddCard(c)
	return res
end
function c19300102.synfilter2(c,lv,g,tuner)
	if not c:IsCode(19300095) then return false end
	local tlv=c:GetLevel()
	if lv-tlv<=0 then return false end
	if not tuner and not c:IsType(TYPE_TUNER) then return false end
	return g:IsExists(c19300102.synfilter3,1,c,lv-tlv)
end
function c19300102.synfilter3(c,lv)
	return c:IsNotTuner() and c:GetLevel()==lv
end
function c19300102.syncon(e,c,tuner)
	if c==nil then return true end
	local tp=c:GetControler()
	local mg=Duel.GetMatchingGroup(c19300102.matfilter,tp,LOCATION_MZONE,LOCATION_MZONE,nil,c)
	local lv=c:GetLevel()
	if tuner then return c19300102.synfilter1(tuner,lv,mg) end
	return mg:IsExists(c19300102.synfilter1,1,nil,lv,mg)
end
function c19300102.synop(e,tp,eg,ep,ev,re,r,rp,c,tuner)
	local g=Group.CreateGroup()
	local mg=Duel.GetMatchingGroup(c19300102.matfilter,tp,LOCATION_MZONE,LOCATION_MZONE,nil,c)
	local lv=c:GetLevel()
	if tuner then
		local lv1=tuner:GetLevel()
		local t=false
		if tuner:IsType(TYPE_TUNER) then t=true end
		mg:RemoveCard(tuner)
		Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_SMATERIAL)
		local t2=mg:FilterSelect(tp,c19300102.synfilter2,1,1,nil,lv-lv1,mg,t)
		local m2=t2:GetFirst()
		g:AddCard(m2)
		local lv2=m2:GetLevel()
		mg:RemoveCard(m2)
		Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_SMATERIAL)
		local t3=mg:FilterSelect(tp,c19300102.synfilter3,1,1,nil,lv-lv1-lv2)
		g:Merge(t3)
	else
		Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_SMATERIAL)
		local t1=mg:FilterSelect(tp,c19300102.synfilter1,1,1,nil,lv,mg)
		local m1=t1:GetFirst()
		g:AddCard(m1)
		local lv1=m1:GetLevel()
		local t=false
		if m1:IsType(TYPE_TUNER) then t=true end
		mg:RemoveCard(m1)
		Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_SMATERIAL)
		local t2=mg:FilterSelect(tp,c19300102.synfilter2,1,1,nil,lv-lv1,mg,t)
		local m2=t2:GetFirst()
		g:AddCard(m2)
		local lv2=m2:GetLevel()
		mg:RemoveCard(m2)
		Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_SMATERIAL)
		local t3=mg:FilterSelect(tp,c19300102.synfilter3,1,1,nil,lv-lv1-lv2)
		g:Merge(t3)
	end
	c:SetMaterial(g)
	Duel.SendtoGrave(g,REASON_MATERIAL+REASON_SYNCHRO)
end
function c19300102.discon(e,tp,eg,ep,ev,re,r,rp)
	local tc=re:GetHandler():GetControler()
	e:SetLabel(tc)
	return not e:GetHandler():IsStatus(STATUS_BATTLE_DESTROYED)
		and not re:GetHandler():IsSetCard(0x193) and Duel.IsChainNegatable(ev)
end
function c19300102.distg(e,tp,eg,ep,ev,re,r,rp,chk)
	local tc=e:GetLabel()
	if chk==0 then return Duel.GetFieldGroupCount(tc,0,LOCATION_DECK)>=4 end
	Duel.SetTargetPlayer(tc)
	Duel.SetOperationInfo(0,CATEGORY_REMOVE,nil,4,tc,LOCATION_DECK)
end
function c19300102.disop(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	local p=Duel.GetChainInfo(0,CHAININFO_TARGET_PLAYER)
	if Duel.GetFieldGroupCount(p,0,LOCATION_DECK)>=4 then
		local g1=Duel.GetDecktopGroup(p,4)
		Duel.DisableShuffleCheck()
		Duel.Remove(g1,POS_FACEUP,REASON_EFFECT)
	end
end