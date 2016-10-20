--Avkhamalasa the Nothing, 4th Arian Guardian
function c77790011.initial_effect(c)
	--dark synchro summon
	c:EnableReviveLimit()
	local e1=Effect.CreateEffect(c)
	e1:SetType(EFFECT_TYPE_FIELD)
	e1:SetCode(EFFECT_SPSUMMON_PROC)
	e1:SetProperty(EFFECT_FLAG_UNCOPYABLE)
	e1:SetRange(LOCATION_EXTRA)
	e1:SetCondition(c77790011.syncon)
	e1:SetOperation(c77790011.synop)
	e1:SetValue(SUMMON_TYPE_SYNCHRO)
	c:RegisterEffect(e1)
	-- atk increase
	local e2=Effect.CreateEffect(c)
	e2:SetType(EFFECT_TYPE_IGNITION)
	e2:SetProperty(EFFECT_FLAG_CARD_TARGET)
	e2:SetRange(LOCATION_MZONE)
	e2:SetCountLimit(1)
	e2:SetCost(c77790011.atkcost)
	e2:SetOperation(c77790011.atkop)
	c:RegisterEffect(e2)
	--battle target
	local e3=Effect.CreateEffect(c)
	e3:SetType(EFFECT_TYPE_SINGLE)
	e3:SetCode(EFFECT_CANNOT_BE_BATTLE_TARGET)
	e3:SetProperty(EFFECT_FLAG_SINGLE_RANGE)
	e3:SetRange(LOCATION_MZONE)
	e3:SetValue(1)
	c:RegisterEffect(e3)
	--negate
	local e4=Effect.CreateEffect(c)
	e4:SetDescription(aux.Stringid(77790011,1))
	e4:SetCategory(CATEGORY_NEGATE+CATEGORY_DESTROY)
	e4:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_QUICK_O)
	e4:SetCode(EVENT_CHAINING)
	e4:SetProperty(EFFECT_FLAG_DAMAGE_STEP+EFFECT_FLAG_DAMAGE_CAL)
	e4:SetRange(LOCATION_MZONE)
	e4:SetCost(c77790011.discost)
	e4:SetCondition(c77790011.discon)
	e4:SetTarget(c77790011.distg)
	e4:SetOperation(c77790011.disop)
	c:RegisterEffect(e4)
end
function c77790011.matfilter1(c,syncard)
	return c:IsSetCard(0x100f) or  c:IsSetCard(0x301) and c:IsType(TYPE_TUNER) and c:IsFaceup() and c:IsCanBeSynchroMaterial(syncard)
end
function c77790011.matfilter2(c,syncard)	
	return c:IsFaceup() and c:IsCanBeSynchroMaterial(syncard) and not c:IsType(TYPE_TUNER)
end
function c77790011.synfilter1(c,lv,g1,g2)
	local tlv=c:GetLevel()	
	if c:GetFlagEffect(100000147)==0 then	
		return g1:IsExists(c77790011.synfilter3,1,nil,lv+tlv)
	else
		return g1:IsExists(c77790011.synfilter3,1,nil,lv-tlv)
	end	
end
function c77790011.synfilter3(c,lv)
	return c:GetLevel()==lv
end
function c77790011.syncon(e,c,tuner)
	if c==nil then return true end
	local tp=c:GetControler()
	if Duel.GetLocationCount(tp,LOCATION_MZONE)<-1 then return false end
	local g1=Duel.GetMatchingGroup(c77790011.matfilter1,tp,LOCATION_MZONE,LOCATION_MZONE,nil,c)
	local g2=Duel.GetMatchingGroup(c77790011.matfilter2,tp,LOCATION_MZONE,LOCATION_MZONE,nil,c)
	local lv=c:GetLevel()
	return g2:IsExists(c77790011.synfilter1,1,nil,lv,g1,g2)
end
function c77790011.synop(e,tp,eg,ep,ev,re,r,rp,c,tuner)
	local g=Group.CreateGroup()
	local g1=Duel.GetMatchingGroup(c77790011.matfilter1,tp,LOCATION_MZONE,LOCATION_MZONE,nil,c)
	local g2=Duel.GetMatchingGroup(c77790011.matfilter2,tp,LOCATION_MZONE,LOCATION_MZONE,nil,c)
	local lv=c:GetLevel()
		Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_SMATERIAL)
		local m3=g2:FilterSelect(tp,c77790011.synfilter1,1,1,nil,lv,g1,g2)
		local mt1=m3:GetFirst()
		g:AddCard(mt1)
		local lv1=mt1:GetLevel()
		Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_SMATERIAL)
		if mt1:GetFlagEffect(100000147)==0 then	
		local t1=g1:FilterSelect(tp,c77790011.synfilter3,1,1,nil,lv+lv1)
		g:Merge(t1)
		else 
		local t1=g1:FilterSelect(tp,c77790011.synfilter3,1,1,nil,lv-lv1)
		g:Merge(t1)
		end			
	c:SetMaterial(g)
	Duel.Hint(HINT_MESSAGE,1-tp,aux.Stringid(77790011,2))
	Duel.Hint(HINT_MESSAGE,1-tp,aux.Stringid(77790011,3))
	Duel.SendtoGrave(g,REASON_MATERIAL+REASON_SYNCHRO)
	Duel.Hint(HINT_MESSAGE,1-tp,aux.Stringid(100000150,4))
end
function c77790011.filter2(c)
	return c:IsType(TYPE_MONSTER) and c:GetBaseAttack()>0 
end
function c77790011.atkcost(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return e:GetHandler():GetFlagEffect(77790011)==0
		and Duel.IsExistingMatchingCard(c77790011.filter2,tp,LOCATION_MZONE,0,1,nil) end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_RELEASE)
	local g2=Duel.SelectMatchingCard(tp,c77790011.filter2,tp,LOCATION_MZONE,0,1,1,nil)
	e:SetLabel(g2:GetFirst():GetAttack())
	Duel.Release(g2,REASON_COST)
end
function c77790011.atkop(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	local e1=Effect.CreateEffect(c)
	e1:SetType(EFFECT_TYPE_SINGLE)
	e1:SetCode(EFFECT_UPDATE_ATTACK)
	e1:SetValue(e:GetLabel())
	e1:SetReset(RESET_EVENT+0x1fe0000)
	c:RegisterEffect(e1)
end
function c77790011.filter3(c)
	return c:IsSetCard(0x301) and c:IsType(TYPE_TUNER) and c:IsAbleToRemoveAsCost()
end
function c77790011.discost(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.IsExistingMatchingCard(c77790011.filter3,tp,LOCATION_GRAVE,0,1,nil) end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_REMOVE)
	local g=Duel.SelectMatchingCard(tp,c77790011.filter3,tp,LOCATION_GRAVE,0,1,1,nil)
	Duel.Remove(g,POS_FACEUP_ATTACK,REASON_COST)
end
function c77790011.discon(e,tp,eg,ep,ev,re,r,rp)
	return not e:GetHandler():IsStatus(STATUS_BATTLE_DESTROYED) and Duel.IsChainNegatable(ev)
end
function c77790011.distg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return true end
	Duel.SetOperationInfo(0,CATEGORY_NEGATE,eg,1,0,0)
	if re:GetHandler():IsDestructable() and re:GetHandler():IsRelateToEffect(re) then
		Duel.SetOperationInfo(0,CATEGORY_DESTROY,eg,1,0,0)
	end
end
function c77790011.disop(e,tp,eg,ep,ev,re,r,rp)
	Duel.NegateActivation(ev)
	if re:GetHandler():IsRelateToEffect(re) then
		Duel.Destroy(eg,REASON_EFFECT)
	end
end
