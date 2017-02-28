--Accel Vocaloid Hatsune Miku - Envoy of the Moonlight Stars
function c5717747.initial_effect(c)
	c:EnableReviveLimit()
	--pendulum summon
	aux.EnablePendulumAttribute(c)
	--cannot special summon
	local e1=Effect.CreateEffect(c)
	e1:SetProperty(EFFECT_FLAG_CANNOT_DISABLE+EFFECT_FLAG_UNCOPYABLE+EFFECT_FLAG_SINGLE_RANGE)
	e1:SetType(EFFECT_TYPE_SINGLE)
	e1:SetRange(LOCATION_EXTRA)
	e1:SetCode(EFFECT_SPSUMMON_CONDITION)
	e1:SetValue(aux.synlimit)
	c:RegisterEffect(e1)
	--synthetic synchro summon
	local e2=Effect.CreateEffect(c)
	e2:SetType(EFFECT_TYPE_FIELD)
	e2:SetCode(EFFECT_SPSUMMON_PROC)
	e2:SetProperty(EFFECT_FLAG_UNCOPYABLE+EFFECT_FLAG_IGNORE_IMMUNE)
	e2:SetRange(LOCATION_EXTRA)
	e2:SetCondition(c5717747.syncon)
	e2:SetOperation(c5717747.synop)
	e2:SetValue(SUMMON_TYPE_SYNCHRO+260)
	c:RegisterEffect(e2)
 	 --synthetic synchro
 	 local e3=Effect.CreateEffect(c)
 	 e3:SetType(EFFECT_TYPE_SINGLE)
 	 e3:SetProperty(EFFECT_FLAG_SINGLE_RANGE)
 	 e3:SetCode(EFFECT_ADD_TYPE)
 	 e3:SetRange(LOCATION_MZONE+LOCATION_GRAVE)
 	 e3:SetValue(TYPE_NORMAL)
 	 c:RegisterEffect(e3)
	--change name
	local e4=Effect.CreateEffect(c)
	e4:SetType(EFFECT_TYPE_SINGLE)
	e4:SetProperty(EFFECT_FLAG_SINGLE_RANGE)
	e4:SetCode(EFFECT_CHANGE_CODE)
	e4:SetRange(LOCATION_MZONE+LOCATION_GRAVE)
	e4:SetValue(58431891)
	c:RegisterEffect(e4)
	--atklimit
	local e5=Effect.CreateEffect(c)
	e5:SetType(EFFECT_TYPE_SINGLE)
	e5:SetCode(EFFECT_CANNOT_SELECT_BATTLE_TARGET)
	e5:SetValue(c5717747.bttg)
	c:RegisterEffect(e5)
	local e6=Effect.CreateEffect(c)
	e6:SetType(EFFECT_TYPE_SINGLE)
	e6:SetCode(EFFECT_CANNOT_DIRECT_ATTACK)
	c:RegisterEffect(e6)
	--immune
	local e7=Effect.CreateEffect(c)
	e7:SetType(EFFECT_TYPE_SINGLE)
	e7:SetProperty(EFFECT_FLAG_SINGLE_RANGE)
	e7:SetRange(LOCATION_MZONE)
	e7:SetCode(EFFECT_IMMUNE_EFFECT)
	e7:SetValue(c5717747.efilter)
	c:RegisterEffect(e7)
	--damage
	local e8=Effect.CreateEffect(c)
	e8:SetDescription(aux.Stringid(5717747,0))
	e8:SetCategory(CATEGORY_DAMAGE)
	e8:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_TRIGGER_F)
	e8:SetCode(EVENT_SPSUMMON_SUCCESS)
	e8:SetRange(LOCATION_MZONE)
	e8:SetCondition(c5717747.damcon)
	e8:SetTarget(c5717747.damtg)
	e8:SetOperation(c5717747.damop)
	c:RegisterEffect(e8)
	--add setcode
	local e9=Effect.CreateEffect(c)
	e9:SetType(EFFECT_TYPE_SINGLE)
	e9:SetProperty(EFFECT_FLAG_CANNOT_DISABLE+EFFECT_FLAG_UNCOPYABLE)
	e9:SetCode(EFFECT_ADD_SETCODE)
	e9:SetValue(0xd72)
	c:RegisterEffect(e9)
end
function c5717747.matfilter(c,syncard)
	return c:IsFaceup() and c:IsCanBeSynchroMaterial(syncard)
end
function c5717747.customfilter(c)
	return c:IsSetCard(0xd71) or c:IsType(TYPE_NORMAL)
end
function c5717747.synfilter1(c,syncard,lv,g)
	local tlv=c:GetSynchroLevel(syncard)
	if lv-tlv<=0 then return false end
	if not c:IsRace(RACE_MACHINE) or not c5717747.customfilter(c) then return false end
	local wg=g:Clone()
	wg:RemoveCard(c)
	return wg:IsExists(c5717747.synfilter2,1,nil,syncard,lv-tlv,wg)
end
function c5717747.synfilter2(c,syncard,lv,g)
	if not c:IsSetCard(0x0dac405) or not c:IsType(TYPE_TUNER) then return false end
	local tlv=c:GetSynchroLevel(syncard)
	if lv-tlv<=0 then return false end
	return g:IsExists(c5717747.synfilter3,1,c,syncard,lv-tlv)
end
function c5717747.synfilter3(c,syncard,lv)
	local mlv=c:GetSynchroLevel(syncard)
	local lv1=bit.band(mlv,0xffff)
	local lv2=bit.rshift(mlv,16)
	return c:IsNotTuner() and (lv1==lv or lv2==lv)
end
function c5717747.syncon(e,c,tuner)
	if c==nil then return true end
	local tp=c:GetControler()
	local mg=Duel.GetMatchingGroup(c5717747.matfilter,tp,LOCATION_MZONE+LOCATION_GRAVE,0,nil,c)
	local lv=c:GetLevel()
	if tuner then return c5717747.synfilter1(tuner,c,lv,mg) end
	return mg:IsExists(c5717747.synfilter1,1,nil,c,lv,mg)
end
function c5717747.synop(e,tp,eg,ep,ev,re,r,rp,c,tuner)
	local g=Group.CreateGroup()
	local mg=Duel.GetMatchingGroup(c5717747.matfilter,tp,LOCATION_MZONE+LOCATION_GRAVE,0,nil,c)
	local lv=c:GetLevel()
	local m1=tuner
	if not tuner then
		Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_SMATERIAL)
		local t1=mg:FilterSelect(tp,c5717747.synfilter1,1,1,nil,c,lv,mg)
		m1=t1:GetFirst()
		g:AddCard(m1)
	end
	lv=lv-m1:GetSynchroLevel(c)
	mg:RemoveCard(m1)
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_REMOVE+HINTMSG_SMATERIAL)
	local t2=mg:FilterSelect(tp,c5717747.synfilter2,1,1,nil,c,lv,mg)
	local m2=t2:GetFirst()
	g:AddCard(m2)
	lv=lv-m2:GetSynchroLevel(c)
	mg:RemoveCard(m2)
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_REMOVE+HINTMSG_SMATERIAL)
	local t3=mg:FilterSelect(tp,c5717747.synfilter3,1,1,nil,c,lv)
	g:Merge(t3)
	c:SetMaterial(g)
	Duel.Remove(g,POS_FACEUP,REASON_MATERIAL+REASON_SYNCHRO)
end
function c5717747.bttg(e,c)
	return c:IsFacedown() or c:IsRace(RACE_MACHINE)
end
function c5717747.efilter(e,te)
	return te:IsActiveType(TYPE_MONSTER) and te:IsActivated() and not te:GetOwner():IsRace(RACE_MACHINE)
end
function c5717747.cfilter(c)
	return not c:IsRace(RACE_MACHINE)
end
function c5717747.damcon(e,tp,eg,ep,ev,re,r,rp)
	return eg:IsExists(c5717747.cfilter,1,nil)
end
function c5717747.damtg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return true end
	local t1=false
	local t2=false
	local tc=eg:GetFirst()
	while tc do
		if not tc:IsRace(RACE_MACHINE) then
			if tc:GetSummonPlayer()==tp then t1=true else t2=true end
		end
		tc=eg:GetNext()
	end
	if t1 and not t2 then Duel.SetOperationInfo(0,CATEGORY_DAMAGE,nil,0,tp,1000)
	elseif not t1 and t2 then Duel.SetOperationInfo(0,CATEGORY_DAMAGE,nil,0,1-tp,1000)
	else Duel.SetOperationInfo(0,CATEGORY_DAMAGE,nil,0,PLAYER_ALL,1000) end
end
function c5717747.damop(e,tp,eg,ep,ev,re,r,rp)
	local ex,g,gc,dp,dv=Duel.GetOperationInfo(0,CATEGORY_DAMAGE)
	if dp~=PLAYER_ALL then Duel.Damage(dp,1000,REASON_EFFECT)
	else
		Duel.Damage(tp,1000,REASON_EFFECT,true)
		Duel.Damage(1-tp,1000,REASON_EFFECT,true)
		Duel.RDComplete()
	end
end
