--Thunder Conductor
function c888000020.initial_effect(c)
	--dark synchro summon
	c:EnableReviveLimit()
	local e1=Effect.CreateEffect(c)
	e1:SetType(EFFECT_TYPE_FIELD)
	e1:SetCode(EFFECT_SPSUMMON_PROC)
	e1:SetProperty(EFFECT_FLAG_UNCOPYABLE)
	e1:SetRange(LOCATION_EXTRA)
	e1:SetCondition(c888000020.syncon)
	e1:SetOperation(c888000020.synop)
	e1:SetValue(SUMMON_TYPE_SYNCHRO)
	c:RegisterEffect(e1)
	--attack
	local e2=Effect.CreateEffect(c)
	e2:SetType(EFFECT_TYPE_SINGLE)
	e2:SetCode(EFFECT_UPDATE_ATTACK)
	e2:SetProperty(EFFECT_FLAG_SINGLE_RANGE)
	e2:SetRange(LOCATION_MZONE)
	e2:SetValue(c888000020.atkval)
	c:RegisterEffect(e2)
	--Paralyzation Counter
	local e3=Effect.CreateEffect(c)
	e3:SetDescription(aux.Stringid(888000020,0))
	e3:SetType(EFFECT_TYPE_IGNITION)
	e3:SetProperty(EFFECT_FLAG_CARD_TARGET)
	e3:SetRange(LOCATION_MZONE)
	e3:SetCountLimit(1)
	e3:SetTarget(c888000020.cttg)
	e3:SetOperation(c888000020.ctop)
	c:RegisterEffect(e3)
	--cannot attack
	local e4=Effect.CreateEffect(c)
	e4:SetType(EFFECT_TYPE_FIELD)
	e4:SetCode(EFFECT_CANNOT_ATTACK)
	e4:SetRange(LOCATION_MZONE)
	e4:SetTargetRange(LOCATION_MZONE,LOCATION_MZONE)
	e4:SetTarget(c888000020.tg)
	c:RegisterEffect(e4)
	--disable
	local e5=Effect.CreateEffect(c)
	e5:SetType(EFFECT_TYPE_FIELD)
	e5:SetRange(LOCATION_MZONE)
	e5:SetTargetRange(LOCATION_ONFIELD,LOCATION_ONFIELD)
	e5:SetCode(EFFECT_DISABLE)
	e5:SetTarget(c888000020.tg)
	c:RegisterEffect(e5)
	local e6=e5:Clone()
	e6:SetCode(EFFECT_CANNOT_TRIGGER)
	c:RegisterEffect(e6)
end
function c888000020.matfilter1(c,syncard)
	return c:IsSetCard(0x301) and c:IsType(TYPE_TUNER) and c:IsFaceup() and c:IsCanBeSynchroMaterial(syncard)
end
function c888000020.matfilter2(c,syncard)	
	return c:IsFaceup() and c:IsCanBeSynchroMaterial(syncard) and not c:IsType(TYPE_TUNER)
end
function c888000020.synfilter1(c,lv,g1,g2)
	local tlv=c:GetLevel()	
	if c:GetFlagEffect(888000020)==0 then	
	return g1:IsExists(c888000020.synfilter3,1,nil,lv+tlv)
	else
	return g1:IsExists(c888000020.synfilter3,1,nil,lv-tlv)
	end	
end
function c888000020.synfilter3(c,lv)
	return c:GetLevel()==lv
end
function c888000020.syncon(e,c,tuner)
	if c==nil then return true end
	local tp=c:GetControler()
	if Duel.GetLocationCount(tp,LOCATION_MZONE)<-1 then return false end
	local g1=Duel.GetMatchingGroup(c888000020.matfilter1,tp,LOCATION_MZONE,LOCATION_MZONE,nil,c)
	local g2=Duel.GetMatchingGroup(c888000020.matfilter2,tp,LOCATION_MZONE,LOCATION_MZONE,nil,c)
	local lv=c:GetLevel()
	return g2:IsExists(c888000020.synfilter1,1,nil,lv,g1,g2)
end
function c888000020.synop(e,tp,eg,ep,ev,re,r,rp,c,tuner)
	local g=Group.CreateGroup()
	local g1=Duel.GetMatchingGroup(c888000020.matfilter1,tp,LOCATION_MZONE,LOCATION_MZONE,nil,c)
	local g2=Duel.GetMatchingGroup(c888000020.matfilter2,tp,LOCATION_MZONE,LOCATION_MZONE,nil,c)
	local lv=c:GetLevel()
		Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_SMATERIAL)
		local m3=g2:FilterSelect(tp,c888000020.synfilter1,1,1,nil,lv,g1,g2)
		local mt1=m3:GetFirst()
		g:AddCard(mt1)
		local lv1=mt1:GetLevel()
		Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_SMATERIAL)
		if mt1:GetFlagEffect(888000020)==0 then	
		local t1=g1:FilterSelect(tp,c888000020.synfilter3,1,1,nil,lv+lv1)
		g:Merge(t1)
		else 
		local t1=g1:FilterSelect(tp,c888000020.synfilter3,1,1,nil,lv-lv1)
		g:Merge(t1)
		end			
	c:SetMaterial(g)
	Duel.Hint(HINT_MESSAGE,1-tp,aux.Stringid(888000020,2))
	Duel.Hint(HINT_MESSAGE,1-tp,aux.Stringid(888000020,3))
	Duel.SendtoGrave(g,REASON_MATERIAL+REASON_SYNCHRO)
	Duel.Hint(HINT_MESSAGE,1-tp,aux.Stringid(888000020,4))
end
function c888000020.atkval(e,c)
	local g1=Duel.GetMatchingGroup(Card.IsFaceup,c:GetControler(),LOCATION_MZONE,LOCATION_MZONE,nil)
	local g2=Duel.GetMatchingGroup(Card.IsFaceup,c:GetControler(),LOCATION_MZONE,LOCATION_MZONE,nil)
	return (g1:GetSum(Card.GetRank)*300)+(g2:GetSum(Card.GetLevel)*300)
end
function c888000020.gfilter(c)
	return c:GetCounter(0x1890)==0
end
function c888000020.cttg(e,tp,eg,ep,ev,re,r,rp,chk,chkc)
	if chkc then return chkc:IsLocation(LOCATION_ONFIELD) end
	if chk==0 then return Duel.IsExistingTarget(c888000020.gfilter,tp,0,LOCATION_ONFIELD,1,nil) end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_TARGET)
	Duel.SelectTarget(tp,c888000020.gfilter,tp,0,LOCATION_ONFIELD,1,2,nil)
end
function c888000020.ctop(e,tp,eg,ep,ev,re,r,rp)
	local g=Duel.GetChainInfo(0,CHAININFO_TARGET_CARDS)
	local c=e:GetHandler()
	local tc=g:GetFirst()
	while tc do
		tc:AddCounter(0x1890,1)
		tc=g:GetNext()
	end
end
function c888000020.tg(e,c)
	return c:GetCounter(0x1890)~=0
end
function c888000020.rcon(e)
	return e:GetOwner():IsHasCardTarget(e:GetHandler())
end