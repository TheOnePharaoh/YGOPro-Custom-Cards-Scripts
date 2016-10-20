--Dark Tuner Dark Pearl
function c888000021.initial_effect(c)
	--dark synchro summon
	c:EnableReviveLimit()
	local e1=Effect.CreateEffect(c)
	e1:SetType(EFFECT_TYPE_FIELD)
	e1:SetCode(EFFECT_SPSUMMON_PROC)
	e1:SetProperty(EFFECT_FLAG_UNCOPYABLE)
	e1:SetRange(LOCATION_EXTRA)
	e1:SetCondition(c888000021.syncon)
	e1:SetOperation(c888000021.synop)
	e1:SetValue(SUMMON_TYPE_SYNCHRO)
	c:RegisterEffect(e1)
	--synchro summon
	local e2=Effect.CreateEffect(c)
	e2:SetType(EFFECT_TYPE_SINGLE)
	e2:SetCode(EFFECT_CANNOT_BE_SYNCHRO_MATERIAL)
	e2:SetProperty(EFFECT_FLAG_CANNOT_DISABLE+EFFECT_FLAG_UNCOPYABLE)
	e2:SetValue(c888000021.synlimit)
	c:RegisterEffect(e2)
	local e3=Effect.CreateEffect(c)
	e3:SetDescription(aux.Stringid(888000021,0))
	e3:SetCategory(CATEGORY_RECOVER)
	e3:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_TRIGGER_F)
	e3:SetProperty(EFFECT_FLAG_CARD_TARGET)
	e3:SetCode(EVENT_BE_MATERIAL)
	e3:SetCondition(c888000021.con)
	e3:SetTarget(c888000021.target)
	e3:SetOperation(c888000021.operation)
	c:RegisterEffect(e3)
	--indes
	local e4=Effect.CreateEffect(c)
	e4:SetType(EFFECT_TYPE_SINGLE)
	e4:SetProperty(EFFECT_FLAG_SINGLE_RANGE)
	e4:SetRange(LOCATION_MZONE)
	e4:SetCode(EFFECT_INDESTRUCTABLE_BATTLE)
	e4:SetValue(1)
	c:RegisterEffect(e4)
	local e5=e4:Clone()
	e5:SetCode(EFFECT_INDESTRUCTABLE_EFFECT)
	c:RegisterEffect(e5)
end
function c888000021.matfilter1(c,syncard)
	return c:IsSetCard(0x301) and c:IsType(TYPE_TUNER) and c:IsFaceup() and c:IsCanBeSynchroMaterial(syncard)
end
function c888000021.matfilter2(c,syncard)	
	return c:IsFaceup() and c:IsCanBeSynchroMaterial(syncard) and not c:IsType(TYPE_TUNER)
end
function c888000021.synfilter1(c,lv,g1,g2)
	local tlv=c:GetLevel()	
	if c:GetFlagEffect(888000021)==0 then	
	return g1:IsExists(c888000021.synfilter3,1,nil,lv+tlv)
	else
	return g1:IsExists(c888000021.synfilter3,1,nil,lv-tlv)
	end	
end
function c888000021.synfilter3(c,lv)
	return c:GetLevel()==lv
end
function c888000021.syncon(e,c,tuner)
	if c==nil then return true end
	local tp=c:GetControler()
	if Duel.GetLocationCount(tp,LOCATION_MZONE)<-1 then return false end
	local g1=Duel.GetMatchingGroup(c888000021.matfilter1,tp,LOCATION_MZONE,LOCATION_MZONE,nil,c)
	local g2=Duel.GetMatchingGroup(c888000021.matfilter2,tp,LOCATION_MZONE,LOCATION_MZONE,nil,c)
	local lv=c:GetLevel()
	return g2:IsExists(c888000021.synfilter1,1,nil,lv,g1,g2)
end
function c888000021.synop(e,tp,eg,ep,ev,re,r,rp,c,tuner)
	local g=Group.CreateGroup()
	local g1=Duel.GetMatchingGroup(c888000021.matfilter1,tp,LOCATION_MZONE,LOCATION_MZONE,nil,c)
	local g2=Duel.GetMatchingGroup(c888000021.matfilter2,tp,LOCATION_MZONE,LOCATION_MZONE,nil,c)
	local lv=c:GetLevel()
		Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_SMATERIAL)
		local m3=g2:FilterSelect(tp,c888000021.synfilter1,1,1,nil,lv,g1,g2)
		local mt1=m3:GetFirst()
		g:AddCard(mt1)
		local lv1=mt1:GetLevel()
		Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_SMATERIAL)
		if mt1:GetFlagEffect(888000021)==0 then	
		local t1=g1:FilterSelect(tp,c888000021.synfilter3,1,1,nil,lv+lv1)
		g:Merge(t1)
		else 
		local t1=g1:FilterSelect(tp,c888000021.synfilter3,1,1,nil,lv-lv1)
		g:Merge(t1)
		end			
	c:SetMaterial(g)
	Duel.Hint(HINT_MESSAGE,1-tp,aux.Stringid(888000021,2))
	Duel.Hint(HINT_MESSAGE,1-tp,aux.Stringid(888000021,3))
	Duel.SendtoGrave(g,REASON_MATERIAL+REASON_SYNCHRO)
	Duel.Hint(HINT_MESSAGE,1-tp,aux.Stringid(888000021,4))
end
function c888000021.synlimit(e,c)
	if not c then return false end
	local code=c:GetOriginalCode()
	if code==100000150 or code==100000151 or code==100000152 or code==100000153 or code==100000154 or code==100000155 or code==100000156 then
	return else return not c:IsSetCard(0x301) end
end
function c888000021.con(e,tp,eg,ep,ev,re,r,rp)
	return e:GetHandler():IsLocation(LOCATION_GRAVE) and r==REASON_SYNCHRO
end
function c888000021.target(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return true end
	local ct=Duel.GetFieldGroupCount(tp,0xc,0xc)
	Duel.SetOperationInfo(0,CATEGORY_RECOVER,nil,0,tp,1200)
	Duel.SetOperationInfo(0,CATEGORY_DAMAGE,nil,0,1-tp,800)
end
function c888000021.operation(e,tp,eg,ep,ev,re,r,rp)
	local ct=Duel.GetFieldGroupCount(tp,0xc,0xc)
	Duel.Recover(tp,ct*500,REASON_EFFECT)
	Duel.Damage(1-tp,ct*400,REASON_EFFECT)
end
