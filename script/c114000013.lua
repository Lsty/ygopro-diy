--★舞台装置の魔女（ヴァルプルギスナハト）
function c114000013.initial_effect(c)
	c:EnableReviveLimit()
	--xyz summon method2
	local e2=Effect.CreateEffect(c)
	e2:SetType(EFFECT_TYPE_FIELD)
	e2:SetCode(EFFECT_SPSUMMON_PROC)
	e2:SetProperty(EFFECT_FLAG_UNCOPYABLE)
	e2:SetDescription(aux.Stringid(114000013,1))
	e2:SetRange(LOCATION_EXTRA)
	e2:SetCondition(c114000013.xyzcon)
	e2:SetOperation(c114000013.xyzop)
	e2:SetValue(SUMMON_TYPE_XYZ)
	c:RegisterEffect(e2)
	--atkup
    local e3=Effect.CreateEffect(c)
    e3:SetType(EFFECT_TYPE_SINGLE)
    e3:SetProperty(EFFECT_FLAG_SINGLE_RANGE)
    e3:SetRange(LOCATION_MZONE)
    e3:SetCode(EFFECT_UPDATE_ATTACK)
    e3:SetValue(c114000013.adval)
    c:RegisterEffect(e3)
	--defup(as_clone_of_atkup)
	local e4=e3:Clone()
	e4:SetCode(EFFECT_UPDATE_DEFENCE)
	c:RegisterEffect(e4)
	--immune
	local e5=Effect.CreateEffect(c)
	e5:SetType(EFFECT_TYPE_SINGLE)
	e5:SetCode(EFFECT_IMMUNE_EFFECT)
	e5:SetProperty(EFFECT_FLAG_SINGLE_RANGE)
	e5:SetRange(LOCATION_MZONE)
	e5:SetCondition(c114000013.immcon)
	e5:SetValue(c114000013.immfilter)
	c:RegisterEffect(e5)
	--destroy mg/trap
	local e6=Effect.CreateEffect(c)
	e6:SetCategory(CATEGORY_DESTROY)
	e6:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_TRIGGER_F)
	e6:SetCode(EVENT_BATTLED)
	e6:SetCondition(c114000013.descon)
	e6:SetOperation(c114000013.desop)
	c:RegisterEffect(e6)
end
--sp summon method 1
function c114000013.xyzfil0(c)
	return c:IsFaceup() and c:IsRace(RACE_SPELLCASTER) and c:GetLevel(4) and not c:IsType(TYPE_TOKEN)
end
function c114000013.XyzCon0(e,c)
	if c==nil then return true end
	local ft=Duel.GetLocationCount(c:GetControler(),LOCATION_MZONE)
	local ct=-ft
	if 4<=ct then return false end
	return Duel.CheckXyzMaterial(c,c114000013.xyzfil0,4,4,4,nil)
end
function c114000013.XyzOp0(e,tp,eg,ep,ev,re,r,rp,c)
	local mg=Duel.SelectXyzMaterial(tp,c,c114000013.xyzfil0,4,4,4)
	c:SetMaterial(mg)
	Duel.Overlay(c,mg)
end
--sp summom method 2
function c114000013.xyzfilter(c,slf)
	return ( c:IsSetCard(0x223) or c:IsSetCard(0x224) 
	or c:IsCode(36405256) or c:IsCode(54360049) or c:IsCode(37160778) or c:IsCode(27491571) or c:IsCode(80741828) or c:IsCode(90330453) --0x223
	or c:IsCode(78010363) or c:IsCode(39432962) or c:IsCode(67511500) or c:IsCode(62379337) or c:IsCode(23087070) or c:IsCode(98358303) or c:IsCode(17720747) or c:IsCode(32751480) or c:IsCode(91584698) ) --0x224
	and c:GetLevel()>0 
	and not c:IsType(TYPE_TOKEN) 
	and c:IsType(TYPE_MONSTER)
	and ( ( c:IsLocation(LOCATION_MZONE) and c:IsFaceup() ) or c:IsLocation(LOCATION_GRAVE) ) 
	and c:IsCanBeXyzMaterial(slf)
end
function c114000013.xyzcon(e,c)
	if c==nil then return true end
	local ft=Duel.GetLocationCount(c:GetControler(),LOCATION_MZONE)
	local ct=-ft
	local abcount=0
	if 4>ct then if Duel.CheckXyzMaterial(c,c114000013.xyzfil0,4,4,4,nil) then abcount=abcount+1 end end
	local mt=Duel.GetMatchingGroup(c114000013.xyzfilter,c:GetControler(),LOCATION_MZONE+LOCATION_GRAVE,0,nil,c)
	local mtf=Duel.GetMatchingGroup(c114000013.xyzfilter,c:GetControler(),LOCATION_MZONE,0,nil,c)
	if mt:GetCount()>0 and Duel.GetFlagEffect(c:GetControler(),114000013)==0 then
		if mtf:GetCount()>ct then abcount=abcount+2 end
	end
	if abcount>0 then
		e:SetLabel(abcount)
		return true
	else
		return false
	end
end

function c114000013.xyzop(e,tp,eg,ep,ev,re,r,rp,c)
	local sel=e:GetLabel()
	if sel==3 then
		Duel.Hint(HINT_SELECTMSG,tp,aux.Stringid(114000013,3))
		sel=Duel.SelectOption(tp,aux.Stringid(114000013,0),aux.Stringid(114000013,1))+1
	end
	local mg
	local g1=Duel.GetMatchingGroup(c114000013.xyzfilter,tp,LOCATION_MZONE,0,nil,c)
	local g2=Duel.GetMatchingGroup(c114000013.xyzfilter,tp,LOCATION_MZONE+LOCATION_GRAVE,0,nil,c)
	local rmg=g2:Clone()
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_XMATERIAL)
	if sel==2 then
		local ft=Duel.GetLocationCount(c:GetControler(),LOCATION_MZONE)
		local ct=-ft
		if ct>=0 then
			local selcount=ct+1
			repeat
				Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_XMATERIAL)
				local ug1=g1:FilterSelect(tp,c114000013.xyzfilter,1,1,nil,c)
				local ugtg=ug1:GetFirst()
				rmg:RemoveCard(ugtg)
				if mg==nil then mg=ug1 else mg:Merge(ug1) end
				selcount=selcount-1
			until selcount==0
			if Duel.SelectYesNo(tp,aux.Stringid(114000013,2)) then
				Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_XMATERIAL)
				local ug2=rmg:FilterSelect(tp,c114000013.xyzfilter,1,99,nil,c)
				mg:Merge(ug2)
			end
		else
			Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_XMATERIAL)
			mg=g2:FilterSelect(tp,c114000013.xyzfilter,1,99,nil,c)
		end
		Duel.RegisterFlagEffect(tp,114000013,0,0,0)
	else
		mg=Duel.SelectXyzMaterial(tp,c,c114000013.xyzfil,4,4,4)
	end
	c:SetMaterial(mg)
	Duel.Overlay(c,mg)
end

--atkup
function c114000013.adval(e,c)
        return c:GetOverlayCount()*700
end
--immune
function c114000013.immcon(e)
	return e:GetHandler():GetOverlayCount()>=3
end
function c114000013.immfilter(e,te)
	return te:IsActiveType(TYPE_MONSTER) and te:GetOwner()~=e:GetOwner()
end
--destroy mg/trap
function c114000013.descon(e,tp,eg,ep,ev,re,r,rp)
	return e:GetHandler()==Duel.GetAttacker() and e:GetHandler():GetOverlayCount()>=4
end
function c114000013.desfilter(c)
	return c:IsType(TYPE_SPELL+TYPE_TRAP) and c:IsDestructable()
end
function c114000013.desop(e,tp,eg,ep,ev,re,r,rp)
	local g=Duel.GetMatchingGroup(c114000013.desfilter,tp,0,LOCATION_ONFIELD,nil)
	Duel.Destroy(g,REASON_EFFECT)
end