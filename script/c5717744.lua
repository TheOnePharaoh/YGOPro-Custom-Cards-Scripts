--Accel Vocaloid Xia Yu Yao
function c5717744.initial_effect(c)
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
	--synchro summon
	local e2=Effect.CreateEffect(c)
	e2:SetType(EFFECT_TYPE_FIELD)
	e2:SetCode(EFFECT_SPSUMMON_PROC)
	e2:SetProperty(EFFECT_FLAG_UNCOPYABLE+EFFECT_FLAG_IGNORE_IMMUNE)
	e2:SetRange(LOCATION_EXTRA)
	e2:SetCondition(c5717744.syncon)
	e2:SetOperation(c5717744.synop)
	e2:SetValue(SUMMON_TYPE_SYNCHRO)
	c:RegisterEffect(e2)
	--to pzone
	local e3=Effect.CreateEffect(c)
	e3:SetProperty(EFFECT_FLAG_DAMAGE_STEP+EFFECT_FLAG_DELAY)
	e3:SetCategory(CATEGORY_DESTROY)
	e3:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_TRIGGER_O)
	e3:SetCode(EVENT_DESTROYED)
	e3:SetCondition(c5717744.con)
	e3:SetOperation(c5717744.op)
	c:RegisterEffect(e3)
 	 --negate & spsummon
 	 local e4=Effect.CreateEffect(c)
 	 e4:SetDescription(aux.Stringid(5717744,0))
 	 e4:SetType(EFFECT_TYPE_QUICK_O)
 	 e4:SetCategory(CATEGORY_DISABLE+CATEGORY_DESTROY+CATEGORY_SPECIAL_SUMMON)
 	 e4:SetCode(EVENT_CHAINING)
	 e4:SetRange(LOCATION_MZONE)
 	 e4:SetProperty(EFFECT_FLAG_DAMAGE_STEP+EFFECT_FLAG_DAMAGE_CAL)
	 e4:SetCountLimit(1)
 	 e4:SetCondition(c5717744.negcon)
 	 e4:SetTarget(c5717744.negtg)
 	 e4:SetOperation(c5717744.negop)
 	 c:RegisterEffect(e4)
	--place pcard
	local e5=Effect.CreateEffect(c)
	e5:SetDescription(aux.Stringid(5717744,2))
	e5:SetType(EFFECT_TYPE_IGNITION)
	e5:SetRange(LOCATION_PZONE)
	e5:SetCountLimit(1,5717744)
	e5:SetCondition(c5717744.pencon)
	e5:SetTarget(c5717744.pentg)
	e5:SetOperation(c5717744.penop)
	c:RegisterEffect(e5)
	--damage
	local e6=Effect.CreateEffect(c)
	e6:SetDescription(aux.Stringid(5717744,3))
	e6:SetCategory(CATEGORY_DAMAGE)
	e6:SetType(EFFECT_TYPE_IGNITION)
	e6:SetProperty(EFFECT_FLAG_PLAYER_TARGET)
	e6:SetRange(LOCATION_PZONE)
	e6:SetCountLimit(1,5717744)
	e6:SetCost(c5717744.damcost)
	e6:SetTarget(c5717744.damtg)
	e6:SetOperation(c5717744.damop)
	c:RegisterEffect(e6)
	--add type
	local e7=Effect.CreateEffect(c)
	e7:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_CONTINUOUS)
	e7:SetProperty(EFFECT_FLAG_CANNOT_DISABLE)
	e7:SetCode(EVENT_SPSUMMON_SUCCESS)
	e7:SetCondition(c5717744.tncon)
	e7:SetOperation(c5717744.tnop)
	c:RegisterEffect(e7)
	local e8=Effect.CreateEffect(c)
	e8:SetType(EFFECT_TYPE_SINGLE)
	e8:SetCode(EFFECT_MATERIAL_CHECK)
	e8:SetValue(c5717744.valcheck)
	e8:SetLabelObject(e7)
	c:RegisterEffect(e8)
	--nontuner
	local e9=Effect.CreateEffect(c)
	e9:SetType(EFFECT_TYPE_SINGLE)
	e9:SetProperty(EFFECT_FLAG_SINGLE_RANGE)
	e9:SetRange(LOCATION_MZONE)
	e9:SetCode(EFFECT_NONTUNER)
	e9:SetCondition(c5717744.tncon)
	c:RegisterEffect(e9)
	local e10=Effect.CreateEffect(c)
	e10:SetType(EFFECT_TYPE_SINGLE)
	e10:SetCode(EFFECT_MATERIAL_CHECK)
	e10:SetValue(c5717744.valcheck)
	e10:SetLabelObject(e7)
	c:RegisterEffect(e10)
end
function c5717744.matfilter(c,syncard)
	return c:IsFaceup() and c:IsCanBeSynchroMaterial(syncard)
end
function c5717744.synfilter1(c,syncard,lv,g)
	local tlv=c:GetSynchroLevel(syncard)
	if lv-tlv<=0 then return false end
	if not c:IsRace(RACE_MACHINE) and c:IsNotTuner() then return false end
	local wg=g:Clone()
	wg:RemoveCard(c)
	return wg:IsExists(c5717744.synfilter2,1,nil,syncard,lv-tlv,wg)
end
function c5717744.synfilter2(c,syncard,lv,g)
	if not c:IsRace(RACE_MACHINE) or not c:IsType(TYPE_SYNCHRO) then return false end
	local tlv=c:GetSynchroLevel(syncard)
	if lv-tlv<=0 then return false end
	return g:IsExists(c5717744.synfilter3,1,c,syncard,lv-tlv)
end
function c5717744.synfilter3(c,syncard,lv)
	local mlv=c:GetSynchroLevel(syncard)
	local lv1=bit.band(mlv,0xffff)
	local lv2=bit.rshift(mlv,16)
	return c:IsRace(RACE_MACHINE) and c:IsNotTuner() and (lv1==lv or lv2==lv)
end
function c5717744.syncon(e,c,tuner)
	if c==nil then return true end
	local tp=c:GetControler()
	local mg=Duel.GetMatchingGroup(c5717744.matfilter,tp,LOCATION_MZONE,LOCATION_MZONE,nil,c)
	local lv=c:GetLevel()
	if tuner then return c5717744.synfilter1(tuner,c,lv,mg) end
	return mg:IsExists(c5717744.synfilter1,1,nil,c,lv,mg)
end
function c5717744.synop(e,tp,eg,ep,ev,re,r,rp,c,tuner)
	local g=Group.CreateGroup()
	local mg=Duel.GetMatchingGroup(c5717744.matfilter,tp,LOCATION_MZONE,LOCATION_MZONE,nil,c)
	local lv=c:GetLevel()
	local m1=tuner
	if not tuner then
		Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_SMATERIAL)
		local t1=mg:FilterSelect(tp,c5717744.synfilter1,1,1,nil,c,lv,mg)
		m1=t1:GetFirst()
		g:AddCard(m1)
	end
	lv=lv-m1:GetSynchroLevel(c)
	mg:RemoveCard(m1)
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_SMATERIAL)
	local t2=mg:FilterSelect(tp,c5717744.synfilter2,1,1,nil,c,lv,mg)
	local m2=t2:GetFirst()
	g:AddCard(m2)
	lv=lv-m2:GetSynchroLevel(c)
	mg:RemoveCard(m2)
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_SMATERIAL)
	local t3=mg:FilterSelect(tp,c5717744.synfilter3,1,1,nil,c,lv)
	g:Merge(t3)
	c:SetMaterial(g)
	Duel.SendtoGrave(g,REASON_MATERIAL+REASON_SYNCHRO)
end
function c5717744.penfilter1(c)
    return c:IsDestructable() and c:GetSequence()==6
end
function c5717744.penfilter2(c)
    return c:IsDestructable() and c:GetSequence()==7
end
function c5717744.con(e,tp,eg,ep,ev,re,r,rp)
    local p1=Duel.GetFieldCard(tp,LOCATION_SZONE,6)
	local p2=Duel.GetFieldCard(tp,LOCATION_SZONE,7)
    if not p1 and not p2 then return false end 
    return (e:GetHandler():IsReason(REASON_EFFECT) or e:GetHandler():IsReason(REASON_BATTLE)) and
	    (p1 and p1:IsDestructable()) or (p2 and p2:IsDestructable()) and e:GetHandler():GetPreviousLocation()==LOCATION_MZONE
end
function c5717744.op(e,tp,eg,ep,ev,re,r,rp)
    local p1=Duel.GetFieldCard(tp,LOCATION_SZONE,6)
	local p2=Duel.GetFieldCard(tp,LOCATION_SZONE,7)
	local g1=nil
	local g2=nil
	if p1 then 
	    g1=Duel.GetMatchingGroup(c5717744.penfilter1,tp,LOCATION_SZONE,0,nil)
	end
	if p2 then 
	    g2=Duel.GetMatchingGroup(c5717744.penfilter2,tp,LOCATION_SZONE,0,nil)
		if g1 then 
		    g1:Merge(g2)
		else 
		    g1=g2
		end
	end
	if g1 and Duel.Destroy(g1,REASON_EFFECT)~=0 then 
	        local c=e:GetHandler()	
	        Duel.MoveToField(c,tp,tp,LOCATION_SZONE,POS_FACEUP,true)
	end 
end
function c5717744.negcon(e,tp,eg,ep,ev,re,r,rp)
  return rp~=tp and re:IsActiveType(TYPE_MONSTER) and Duel.IsChainNegatable(ev) and not e:GetHandler():IsStatus(STATUS_BATTLE_DESTROYED)
end
function c5717744.negtg(e,tp,eg,ep,ev,re,r,rp,chk)
  if chk==0 then return true end
  Duel.SetOperationInfo(0,CATEGORY_DISABLE,eg,1,0,0)
	if re:GetHandler():IsDestructable() and re:GetHandler():IsRelateToEffect(re) then
		Duel.SetOperationInfo(0,CATEGORY_DESTROY,eg,1,0,0)
	end
end
function c5717744.negfil(c,e,tp)
  return c:IsCode(5717744) and c:IsCanBeSpecialSummoned(e,0,tp,true,false)
end
function c5717744.negop(e,tp,eg,ep,ev,re,r,rp)
	Duel.NegateEffect(ev)
	if re:GetHandler():IsRelateToEffect(re) and Duel.Destroy(eg,REASON_EFFECT)>0 then
		if Duel.GetLocationCount(tp,LOCATION_MZONE)<=0 then return end
		local g=Duel.GetMatchingGroup(c5717744.negfil,tp,LOCATION_EXTRA,0,nil,e,tp)
		if g:GetCount()>0 and Duel.SelectYesNo(tp,aux.Stringid(5717744,1)) then
			Duel.BreakEffect()
			Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_SPSUMMON)
			local sg=g:Select(tp,1,1,nil)
			Duel.SpecialSummon(sg,0,tp,tp,true,false,POS_FACEUP_ATTACK)
		end
	end
end
function c5717744.pencost(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.IsExistingMatchingCard(Card.IsDiscardable,tp,LOCATION_HAND,0,1,e:GetHandler()) end
	Duel.DiscardHand(tp,Card.IsDiscardable,1,1,REASON_COST+REASON_DISCARD)
end
function c5717744.penfilter4(c)
    return c:IsRace(RACE_MACHINE) and c:IsType(TYPE_PENDULUM)
end
function c5717744.pencon(e,tp,eg,ep,ev,re,r,rp)
    local seq=e:GetHandler():GetSequence()
	return Duel.GetFieldCard(tp,LOCATION_SZONE,13-seq)==nil 
end
function c5717744.pentg(e,tp,eg,ep,ev,re,r,rp,chk)
    if chk==0 then return Duel.IsExistingMatchingCard(c5717744.penfilter4,tp,LOCATION_EXTRA,0,1,nil) end
end
function c5717744.penop(e,tp,eg,ep,ev,re,r,rp)
    Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_TOFIELD)
	local g=Duel.SelectMatchingCard(tp,c5717744.penfilter4,tp,LOCATION_EXTRA,0,1,1,nil)
	if g:GetCount()>0 then 
	    local tc=g:GetFirst()
		Duel.MoveToField(tc,tp,tp,LOCATION_SZONE,POS_FACEUP,true)
	end
end
function c5717744.tgfilter(c)
	return c:IsSetCard(0x0dac405) and c:IsAbleToGraveAsCost()
end
function c5717744.damcost(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.IsExistingMatchingCard(c5717744.tgfilter,tp,LOCATION_DECK,0,1,nil) end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_TOGRAVE)
	local g=Duel.SelectMatchingCard(tp,c5717744.tgfilter,tp,LOCATION_DECK,0,1,1,nil)
	Duel.SendtoGrave(g,REASON_COST)
end
function c5717744.damtg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return true end
	Duel.SetTargetPlayer(1-tp)
	Duel.SetTargetParam(300)
	Duel.SetOperationInfo(0,CATEGORY_DAMAGE,nil,0,1-tp,300)
end
function c5717744.damop(e,tp,eg,ep,ev,re,r,rp)
	local p,d=Duel.GetChainInfo(0,CHAININFO_TARGET_PLAYER,CHAININFO_TARGET_PARAM)
	Duel.Damage(p,d,REASON_EFFECT)
end
function c5717744.valcheck(e,c)
	local g=c:GetMaterial()
	if g:IsExists(Card.IsSetCard,1,nil,0x0dac402) then
		e:GetLabelObject():SetLabel(1)
	else
		e:GetLabelObject():SetLabel(0)
	end
end
function c5717744.tncon(e,tp,eg,ep,ev,re,r,rp)
	return e:GetHandler():GetSummonType()==SUMMON_TYPE_SYNCHRO and e:GetLabel()==1
end
function c5717744.tnop(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	local e1=Effect.CreateEffect(c)
	e1:SetType(EFFECT_TYPE_SINGLE)
	e1:SetProperty(EFFECT_FLAG_CANNOT_DISABLE)
	e1:SetCode(EFFECT_ADD_TYPE)
	e1:SetValue(TYPE_TUNER)
	e1:SetReset(RESET_EVENT+0x1fe0000)
	c:RegisterEffect(e1)
end
