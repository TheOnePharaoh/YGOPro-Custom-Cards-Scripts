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
	--synthetic synchro summon
	local e2=Effect.CreateEffect(c)
	e2:SetType(EFFECT_TYPE_FIELD)
	e2:SetCode(EFFECT_SPSUMMON_PROC)
	e2:SetProperty(EFFECT_FLAG_UNCOPYABLE+EFFECT_FLAG_IGNORE_IMMUNE)
	e2:SetRange(LOCATION_EXTRA)
	e2:SetCondition(c5717744.syncon)
	e2:SetOperation(c5717744.synop)
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
 	 --damage
 	 local e6=Effect.CreateEffect(c)
 	 e6:SetDescription(aux.Stringid(5717744,2))
 	 e6:SetCategory(CATEGORY_DAMAGE)
 	 e6:SetType(EFFECT_TYPE_IGNITION)
 	 e6:SetProperty(EFFECT_FLAG_PLAYER_TARGET)
 	 e6:SetRange(LOCATION_MZONE)
 	 e6:SetCountLimit(1)
 	 e6:SetCost(c5717744.damcost)
 	 e6:SetTarget(c5717744.damtg)
 	 e6:SetOperation(c5717744.damop)
 	 c:RegisterEffect(e6)
	--add setcode
	local e7=Effect.CreateEffect(c)
	e7:SetType(EFFECT_TYPE_SINGLE)
	e7:SetProperty(EFFECT_FLAG_CANNOT_DISABLE+EFFECT_FLAG_UNCOPYABLE)
	e7:SetCode(EFFECT_ADD_SETCODE)
	e7:SetValue(0xd72)
	c:RegisterEffect(e7)
end
function c5717744.matfilter(c,syncard)
	return c:IsFaceup() and c:IsCanBeSynchroMaterial(syncard)
end
function c5717744.customfilter(c)
	return c:IsSetCard(0xd71) or c:IsType(TYPE_NORMAL)
end
function c5717744.synfilter1(c,syncard,lv,g)
	local tlv=c:GetSynchroLevel(syncard)
	if lv-tlv<=0 then return false end
	if not c:IsRace(RACE_MACHINE) or not c5717744.customfilter(c) then return false end
	local wg=g:Clone()
	wg:RemoveCard(c)
	return wg:IsExists(c5717744.synfilter2,1,nil,syncard,lv-tlv,wg)
end
function c5717744.synfilter2(c,syncard,lv,g)
	if not c:IsSetCard(0x0dac405) or not c:IsType(TYPE_TUNER) then return false end
	local tlv=c:GetSynchroLevel(syncard)
	if lv-tlv<=0 then return false end
	return g:IsExists(c5717744.synfilter3,1,c,syncard,lv-tlv)
end
function c5717744.synfilter3(c,syncard,lv)
	local mlv=c:GetSynchroLevel(syncard)
	local lv1=bit.band(mlv,0xffff)
	local lv2=bit.rshift(mlv,16)
	return c:IsNotTuner() and (lv1==lv or lv2==lv)
end
function c5717744.syncon(e,c,tuner)
	if c==nil then return true end
	local tp=c:GetControler()
	local mg=Duel.GetMatchingGroup(c5717744.matfilter,tp,LOCATION_MZONE+LOCATION_GRAVE,0,nil,c)
	local lv=c:GetLevel()
	if tuner then return c5717744.synfilter1(tuner,c,lv,mg) end
	return mg:IsExists(c5717744.synfilter1,1,nil,c,lv,mg)
end
function c5717744.synop(e,tp,eg,ep,ev,re,r,rp,c,tuner)
	local g=Group.CreateGroup()
	local mg=Duel.GetMatchingGroup(c5717744.matfilter,tp,LOCATION_MZONE+LOCATION_GRAVE,0,nil,c)
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
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_REMOVE+HINTMSG_SMATERIAL)
	local t2=mg:FilterSelect(tp,c5717744.synfilter2,1,1,nil,c,lv,mg)
	local m2=t2:GetFirst()
	g:AddCard(m2)
	lv=lv-m2:GetSynchroLevel(c)
	mg:RemoveCard(m2)
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_REMOVE+HINTMSG_SMATERIAL)
	local t3=mg:FilterSelect(tp,c5717744.synfilter3,1,1,nil,c,lv)
	g:Merge(t3)
	c:SetMaterial(g)
	Duel.Remove(g,POS_FACEUP,REASON_MATERIAL+REASON_SYNCHRO)
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
