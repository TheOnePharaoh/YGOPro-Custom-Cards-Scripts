--Chaos Nova Dragon
function c999919.initial_effect(c)
	--synchro summon
	c999919.tuner_filter=function(mc) return true end
	c999919.nontuner_filter=function(mc) return mc and mc:IsCode(70902743) end
	c999919.minntct=1
	c999919.maxntct=1
	c999919.sync=true
	c999919.dobtun=true
	c:EnableReviveLimit()
	local e1=Effect.CreateEffect(c)
	e1:SetType(EFFECT_TYPE_FIELD)
	e1:SetCode(EFFECT_SPSUMMON_PROC)
	e1:SetProperty(EFFECT_FLAG_UNCOPYABLE+EFFECT_FLAG_IGNORE_IMMUNE)
	e1:SetRange(LOCATION_EXTRA)
	e1:SetCondition(c999919.syncon)
	e1:SetOperation(c999919.synop)
	e1:SetValue(SUMMON_TYPE_SYNCHRO)
	c:RegisterEffect(e1)
	--pierce
	local e2=Effect.CreateEffect(c)
	e2:SetType(EFFECT_TYPE_SINGLE)
	e2:SetCode(EFFECT_PIERCE)
	c:RegisterEffect(e2)
	--indes
	local e3=Effect.CreateEffect(c)
	e3:SetType(EFFECT_TYPE_SINGLE)
	e3:SetProperty(EFFECT_FLAG_SINGLE_RANGE)
	e3:SetRange(LOCATION_MZONE)
	e3:SetCode(EFFECT_INDESTRUCTABLE_BATTLE)
	e3:SetValue(1)
	c:RegisterEffect(e3)
	local e4=e3:Clone()
	e4:SetCode(EFFECT_INDESTRUCTABLE_EFFECT)
	c:RegisterEffect(e4)
	--atk
	local e5=Effect.CreateEffect(c)
	e5:SetDescription(aux.Stringid(999919,0))
	e5:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_TRIGGER_F)
	e5:SetRange(LOCATION_MZONE)
	e5:SetCode(EVENT_DAMAGE)
	e5:SetCondition(c999919.atkcon)
	e5:SetOperation(c999919.atkop)
	c:RegisterEffect(e5)
	--cannot diratk
	local e6=Effect.CreateEffect(c)
	e6:SetType(EFFECT_TYPE_SINGLE)
	e6:SetCode(EFFECT_CANNOT_DIRECT_ATTACK)
	c:RegisterEffect(e6)
	--cannot attack announce
	local e7=Effect.CreateEffect(c)
	e7:SetType(EFFECT_TYPE_FIELD)
	e7:SetRange(LOCATION_MZONE)
	e7:SetCode(EFFECT_CANNOT_ATTACK)
	e7:SetTargetRange(LOCATION_MZONE,0)
	e7:SetTarget(c999919.antarget)
	c:RegisterEffect(e7)
end
function c999919.matfilter1(c,syncard)
	return c:IsType(TYPE_TUNER) and c:IsFaceup() and c:IsCanBeSynchroMaterial(syncard)
end
function c999919.matfilter2(c,syncard)
	return c:IsFaceup() and c:IsCode(70902743) or c:IsCode(999910) and c:IsCanBeSynchroMaterial(syncard)
end
function c999919.synfilter1(c,lv,g1,g2)
	local tlv=c:GetLevel()
	if lv-tlv<=0 then return false end
	local f1=c.tuner_filter
	return g1:IsExists(c999919.synfilter2,1,c,lv-tlv,g2,f1,c)
end
function c999919.synfilter2(c,lv,g2,f1,tuner1)
	local tlv=c:GetLevel()
	if lv-tlv<=0 then return false end
	local f2=c.tuner_filter
	if f1 and not f1(c) then return false end
	if f2 and not f2(tuner1) then return false end
	return g2:IsExists(c999919.synfilter3,1,nil,lv-tlv,f1,f2)
end
function c999919.synfilter3(c,lv,f1,f2)
	return c:GetLevel()==lv and (not f1 or f1(c)) and (not f2 or f2(c))
end
function c999919.syncon(e,c,tuner)
	if c==nil then return true end
	local tp=c:GetControler()
	if Duel.GetLocationCount(tp,LOCATION_MZONE)<-2 then return false end
	local g1=Duel.GetMatchingGroup(c999919.matfilter1,tp,LOCATION_MZONE,LOCATION_MZONE,nil,c)
	local g2=Duel.GetMatchingGroup(c999919.matfilter2,tp,LOCATION_MZONE,LOCATION_MZONE,nil,c)
	local pe=Duel.IsPlayerAffectedByEffect(tp,EFFECT_MUST_BE_SMATERIAL)
	local lv=c:GetLevel()
	if tuner then
		local tlv=tuner:GetLevel()
		if lv-tlv<=0 then return false end
		local f1=tuner.tuner_filter
		if not pe then
			return g1:IsExists(c999919.synfilter2,1,tuner,lv-tlv,g2,f1,tuner)
		else
			return c999919.synfilter2(pe:GetOwner(),lv-tlv,g2,f1,tuner)
		end
	end
	if not pe then
		return g1:IsExists(c999919.synfilter1,1,nil,lv,g1,g2)
	else
		return c999919.synfilter1(pe:GetOwner(),lv,g1,g2)
	end
end
function c999919.synop(e,tp,eg,ep,ev,re,r,rp,c,tuner)
	local g=Group.CreateGroup()
	local g1=Duel.GetMatchingGroup(c999919.matfilter1,tp,LOCATION_MZONE,LOCATION_MZONE,nil,c)
	local g2=Duel.GetMatchingGroup(c999919.matfilter2,tp,LOCATION_MZONE,LOCATION_MZONE,nil,c)
	local pe=Duel.IsPlayerAffectedByEffect(tp,EFFECT_MUST_BE_SMATERIAL)
	local lv=c:GetLevel()
	if tuner then
		g:AddCard(tuner)
		local lv1=tuner:GetLevel()
		local f1=tuner.tuner_filter
		Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_SMATERIAL)
		local tuner2=nil
		if not pe then
			local t2=g1:FilterSelect(tp,c999919.synfilter2,1,1,tuner,lv-lv1,g2,f1,tuner)
			tuner2=t2:GetFirst()
		else
			tuner2=pe:GetOwner()
			Group.FromCards(tuner2):Select(tp,1,1,nil)
		end
		g:AddCard(tuner2)
		local lv2=tuner2:GetLevel()
		local f2=tuner2.tuner_filter
		Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_SMATERIAL)
		local m3=g2:FilterSelect(tp,c999919.synfilter3,1,1,nil,lv-lv1-lv2,f1,f2)
		g:Merge(m3)
	else
		Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_SMATERIAL)
		local tuner1=nil
		if not pe then
			local t1=g1:FilterSelect(tp,c999919.synfilter1,1,1,nil,lv,g1,g2)
			tuner1=t1:GetFirst()
		else
			tuner1=pe:GetOwner()
			Group.FromCards(tuner1):Select(tp,1,1,nil)
		end
		g:AddCard(tuner1)
		local lv1=tuner1:GetLevel()
		local f1=tuner1.tuner_filter
		Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_SMATERIAL)
		local t2=g1:FilterSelect(tp,c999919.synfilter2,1,1,tuner1,lv-lv1,g2,f1,tuner1)
		local tuner2=t2:GetFirst()
		g:AddCard(tuner2)
		local lv2=tuner2:GetLevel()
		local f2=tuner2.tuner_filter
		Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_SMATERIAL)
		local m3=g2:FilterSelect(tp,c999919.synfilter3,1,1,nil,lv-lv1-lv2,f1,f2)
		g:Merge(m3)
	end
	c:SetMaterial(g)
	Duel.SendtoGrave(g,REASON_MATERIAL+REASON_SYNCHRO)
end
function c999919.atkcon(e,tp,eg,ep,ev,re,r,rp)
	if ep~=tp then return false end
	if bit.band(r,REASON_EFFECT)~=0 then return rp~=tp end
	return e:GetHandler():IsRelateToBattle()
end
function c999919.atkop(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	if c:IsFaceup() and c:IsRelateToEffect(e) then
		local e1=Effect.CreateEffect(c)
		e1:SetType(EFFECT_TYPE_SINGLE)
		e1:SetCode(EFFECT_UPDATE_ATTACK)
		e1:SetValue(ev)
		e1:SetReset(RESET_EVENT+0x1ff0000)
		c:RegisterEffect(e1)
	end
end
function c999919.antarget(e,c)
	return c~=e:GetHandler()
end
